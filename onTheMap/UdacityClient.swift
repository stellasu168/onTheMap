//
//  UdacityClient.swift
//  onTheMap
//
//  Created by Stella Su on 11/9/15.
//  Copyright © 2015 Million Stars, LLC. All rights reserved.
//

import Foundation
import UIKit

class UdacityClient: NSObject {

    static let sharedInstance = UdacityClient()
    
    var sessionID: String? = nil
    var userID: String? = nil
    //var loginError: String? = nil
    
    var firstName: String? = nil
    var lastName: String? = nil
    var latitude: Double? = nil
    var longitude: Double? = nil
    var mediaURL: String? = nil
    var mapString: String? = nil

    
    override init() {
        super.init()
    }
    
    //MARK: - Methods
    
    func loginWithInput(email: String, password: String, completion: (user: Dictionary<String, AnyObject>?, errorMessage: String?) -> Void) {
        
        
        /* 2. Build the URL */
        let urlString = "https://www.udacity.com/api/session"
        
        /* 3. Configure the request */
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                dispatch_async(dispatch_get_main_queue(), {
                    completion(user: nil, errorMessage: error!.localizedDescription)
                })
                return
            }
            
        /* 5. Parse the data */
        let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            
        let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
                
                guard let session = parsedResult["session"] as? [String: String] else {
                    print("Login Failed - can't get session from Udacity")
                    
                    if let errorMessage = parsedResult["error"] as? String {
                        dispatch_async(dispatch_get_main_queue(), {
                            completion(user: nil, errorMessage: errorMessage)
                        })
                    }
                    
                    return
                }
                
            /* GUARD: Is the "sessionID" key in parsedResult? */
            guard let sessionID = session["id"] else {
                    print("Cannot find key 'session' in \(parsedResult)")
                    return
                }
                
            /* 6. Use the data */
            dispatch_async(dispatch_get_main_queue(), {
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDelegate.sessionID = sessionID
                    guard let jsonResult = parsedResult as? Dictionary<String, AnyObject> else {
                        completion(user: nil, errorMessage: "Could not find user")
                        return
                    }
                
                completion(user: jsonResult, errorMessage: nil)
                
                // Calling getAuthenticatedUser
                self.getAuthenticatedUser(completion)

                })
            } catch {
                parsedResult = nil
                print("Could not parse the data as JSON: '\(data)'")
                return
            }
        }
        
        
        /* 7. Start the request */
        task.resume()
        
    }
    
    func getAuthenticatedUser(completion: (user: [String: AnyObject]?, error: String?) -> Void) {
        
        print("getAuthenticatedUser was called")
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        guard let userId = appDelegate.userKey else {return}
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/\(userId)")!)
        self.userID = userId
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completion(user: nil, error: error!.localizedDescription)
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
                if let responseCode = parsedResult["status"] as? Int {
                    print("Response code: \(responseCode)")
                    if responseCode == 404 {
                        completion(user: nil, error: "User not found")
                    }
                    return
                }
        
                
                if let user = parsedResult["user"] as? [String: AnyObject] {
                    if let first_name = user["first_name"] as? String {
                        self.firstName = first_name
                        
                    }
                    if let last_name = user["last_name"] as? String {
                        self.lastName = last_name
                    }
   
                    
                }
                
                guard let user = parsedResult["user"] as? [String: AnyObject] else {
                    print("Failed to cast user as Dictionary<String, AnyObject>")
                    return
                }
                
                
                completion(user: user, error: nil)
            } catch {
                completion(user: nil, error: "Error obtaining data")
            }
            
        }
        
        
        task.resume()
    }
    
    //MARK: - DELETE
    
    // Deleteing (logging out of)a session
    
    func logoutSession() {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! as [NSHTTPCookie] {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error
                print("Failed to delete session: \(error!.localizedDescription)")
                // Do something to show alert to users
                
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) // Subset response data!
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
           

        }
        task.resume()
        
        // *** Reset app delegate data
        
    }
    
    
}
