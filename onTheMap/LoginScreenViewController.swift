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
        
        // If both usename and password are not empty, do this ...
        UdacityClient.sharedInstance.loginWithInput(emailTextField.text!, password: passwordTextField.text!, completion: {
            (user, error) in
            if error != nil {
                print("login error")
                return
            }
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            guard let user = user else {return}
            
            if let account = user["account"] as? Dictionary<String, AnyObject> {
                appDelegate.userKey = account["key"] as? String

                return
            }
            
            print("Could not log in at this time")
        })
        
               
        
        // If all looks good, it will segue to Map and Table Tabbed View
        completeLogin()
    }
    
    func completeLogin(){
        
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("mapViewVC") as! UITabBarController
        self.presentViewController(controller, animated: true, completion: nil)

    }
    
    
    @IBAction func signUpButtonTouch(sender: AnyObject) {
        
        // Open Safari when Sign Up is clicked
        let url = NSURL(string: "https://www.udacity.com/account/auth#!/signup")
        UIApplication.sharedApplication().openURL(url!)
        
    }
}

