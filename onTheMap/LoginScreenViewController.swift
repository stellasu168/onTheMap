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

    @IBAction func loginButtonTouch(sender: AnyObject) {
        
        // If and/or email and password are empty, send an alert to user
        if (emailTextField.text == "" || passwordTextField.text == ""){
            alert("Email or password should not be empty")
            return
        }
        
        // *** Validate users
        UdacityClient.sharedInstance.loginWithInput(emailTextField.text!, password: passwordTextField.text!, completion: {
            (user, error) in
            if error != nil {
                
                self.alert("\(error!.localizedUppercaseString)")
                
            } else {
            
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
                guard let user = user else {return}
            
                if let account = user["account"] as? Dictionary<String, AnyObject> {
                    appDelegate.userKey = account["key"] as? String
                    
                    // If all looks good, it will segue to Map and Table Tabbed View
                    self.completeLogin()

                }
                
            }
        
        })
        
    }
    
    func completeLogin(){
        
        dispatch_async(dispatch_get_main_queue(),{
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("mapViewVC") as! UITabBarController
        self.presentViewController(controller, animated: true, completion: nil)
        } )

    }
    
    func alert(message: String) {
        dispatch_async(dispatch_get_main_queue(), {
            
            let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            
            // show the alert
            self.presentViewController(alert, animated: true, completion: nil)
        })
    }
    
    
    @IBAction func signUpButtonTouch(sender: AnyObject) {
        // Open Safari when Sign Up is clicked
        let url = NSURL(string: "https://www.udacity.com/account/auth#!/signup")
        UIApplication.sharedApplication().openURL(url!)
        
    }
}

