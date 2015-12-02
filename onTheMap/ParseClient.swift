//
//  ParseClient.swift
//  onTheMap
//
//  Created by Stella Su on 11/6/15.
//  Copyright © 2015 Million Stars, LLC. All rights reserved.
//
import Foundation

class ParseClient: NSObject {

    // Shared session
    var session: NSURLSession
    
    // Student location arrays
    var studentLocations = [StudentLocation]()
    
    // MARK: Initializers
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    // MARK: Get
    
    func taskForGetMethod(method: String, parameters: [String : AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        // Build the URL and configure the request
        let urlString = ParseClient.Constants.BaseURLSecure + method + ParseClient.escapedParameters(parameters)
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        
        request.addValue(Constants.ParseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.RestAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        // Make the request
        let task = session.dataTaskWithRequest(request) { data, response, downloadError in
            // Parse and use the data (happens in completion handler)
            if let error = downloadError{
                print("taskForGetMethod - \(error.localizedDescription)")
                
            }
            else {
                ParseClient.parseJSONWithCompletionHandler(data!, completionHandler: completionHandler)
            }
        }
        // Start the request
        task.resume()
        
        return task
    }
    
    // MARK: POST
    
    func taskForPostMethod(method: String, jsonBody: [String : AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        // Build the URL and configure the request
        let urlString = ParseClient.Constants.BaseURLSecure + method
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        
        var jsonifyError: NSError? = nil
        
        request.HTTPMethod = "POST"
        request.addValue(Constants.ParseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.RestAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(jsonBody, options: [])
        } catch let error as NSError {
            jsonifyError = error
            print("taskForPostMethod - \(jsonifyError)")
            request.HTTPBody = nil
        }
        
        // Make the request
        let task = session.dataTaskWithRequest(request) { data, response, downloadError in
            
            // Parse and use the data
            if let error = downloadError {
                let newError = ParseClient.errorForData(data, response: response, error: error)
                print("taskForPostMethod - \(newError)")
                completionHandler(result: nil, error: newError)
            } else {
                ParseClient.parseJSONWithCompletionHandler(data!, completionHandler: completionHandler)
            }
        }
        
        // Start the request
        task.resume()
        
        return task
    }
/*
    // MARK: PUT
    func taskForPutMethod(method: String, jsonBody: [String : AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        // Build the URL and configure the request
        let urlString = ParseClient.Constants.BaseURLSecure + method
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        
        var jsonifyError: NSError? = nil
        
        request.HTTPMethod = "PUT"
        request.addValue(Constants.ParseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.RestAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(jsonBody, options: [])
        } catch let error as NSError {
            jsonifyError = error
            print(jsonifyError)
            request.HTTPBody = nil
        }
        

        // Make the request
        let task = session.dataTaskWithRequest(request) { data, response, downloadError in
            
            // Parse and use the data (happens in completion handler)
            if let error = downloadError {
                let newError = ParseClient.errorForData(data, response: response, error: error)
                completionHandler(result: nil, error: newError)
                print("taskForPutMethod - \(error.localizedDescription)")
                
            }
            else {
                ParseClient.parseJSONWithCompletionHandler(data!, completionHandler: completionHandler)
            }
        }
        
        // Start the request
        task.resume()
        
        return task
    }
    
*/
    // MARK: Helpers
    
    // Helper: Given a response with error, see if a status_message is returned, otherwise return the previous error
    class func errorForData(data: NSData?, response: NSURLResponse?, error: NSError?) -> NSError {
     
/*        if data == nil {
            
            print("errorForData - \(error?.localizedDescription)")
            return error!
            
        }
*/
        
        if let parsedResult = (try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as? [String : AnyObject] {
            if let errorMessage = parsedResult[ParseClient.JSONResponseKeys.StatusMessage] as? String {
             
                let userInfo = [NSLocalizedDescriptionKey : errorMessage]
                if let errorCode = parsedResult[ParseClient.JSONResponseKeys.StatusCode] as? Int {
                    return NSError(domain: "Parse Error", code: errorCode, userInfo: userInfo)
                }
                
                return NSError(domain: "Parse Error", code: 1, userInfo: userInfo)
            }
        }
        
        return error!
    }
    
    // Helper: Given raw JSON, return a useable Foundation object
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsingError: NSError? = nil
        
        let parsedResult: AnyObject?
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
        } catch let error as NSError {
            parsingError = error
            parsedResult = nil
        }
        
        if let error = parsingError {
            completionHandler(result: nil, error: error)
        }
        else {
            if let _ = parsedResult?.valueForKey(ParseClient.JSONResponseKeys.StatusMessage) as? String {
                let newError = errorForData(data, response: nil, error: nil)
                completionHandler(result: nil, error: newError)
                print(newError)
            }
            else {
                completionHandler(result: parsedResult, error: nil)
            }
            
        }
    }
    
    // Helper function: Given a dictionary of parameters, convert to a string for a url
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        let queryItems = parameters.map { NSURLQueryItem(name: $0, value: $1 as? String) }
        let components = NSURLComponents()
        
        components.queryItems = queryItems
        return components.percentEncodedQuery ?? ""
    }
    
    // MARK: Shared Instance
    class func sharedInstance() -> ParseClient {
       
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        
        return Singleton.sharedInstance
    }

    
    
    
}

