//
//  LoginScreenViewController.swift
//  onTheMap
//
//  Created by Stella Su on 11/1/15.
//  Copyright © 2015 Million Stars, LLC. All rights reserved.
//

import UIKit
import MapKit

class LoginScreenViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var appDelegate = AppDelegate!.self
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func loginButtonTouch(sender: AnyObject) {
        
        // If both usename and password are not empty, do this ...
        
        /* 2. Build the URL */
        let urlString = "https://www.udacity.com/api/session"
        
        /* 3. Configure the request */
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(emailTextField.text!)\", \"password\": \"\(passwordTextField.text!)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                print("Error connecting to Udacity")
                return
            }
            
        
        /* 5. Parse the data */
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            let parsedResult: AnyObject!
                do {
                    parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
                } catch {
                    parsedResult = nil
                    print("Could not parse the data as JSON: '\(data)'")
                    return
                }

            /* GUARD: Is the "sessionID" key in parsedResult? */
            guard let sessionID = parsedResult["session"] as? String else {
                dispatch_async(dispatch_get_main_queue()) {
                    print("Login Failed")
                }
                    print("Cannot find key 'session' in \(parsedResult)")
                    return
                }
            
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            
        /* 6. Use the data */
        //self.appDelegate.sessionID = sessionID
            print(sessionID)
            
        }
        
        /* 7. Start the request */
        task.resume()
        
        
        // If all looks good, it will segue to Map and Table Tabbed View
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("mapViewVC") as! UITabBarController
        self.presentViewController(controller, animated: true, completion: nil)
        
    }
    
    func completeLogin(){
        
    }
    
    
    @IBAction func signUpButtonTouch(sender: AnyObject) {
        // Open Safari when Sign Up is clicked
        let url = NSURL(string: "https://www.udacity.com/account/auth#!/signup")
        UIApplication.sharedApplication().openURL(url!)
        
    }
}

