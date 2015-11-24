//
//  ListViewController.swift
//  onTheMap
//
//  Created by Stella Su on 11/6/15.
//  Copyright © 2015 Million Stars, LLC. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {

    @IBOutlet var studentLocationtableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        getStudentData()
    }

    //MARK: Actions
    
   @IBAction func refreshButtonClicked(sender: AnyObject) {
        getStudentData()
    }
    
    @IBAction func logoutClicked(sender: AnyObject) {
        UdacityClient.sharedInstance.logoutSession()
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("loginView")
        self.presentViewController(controller!, animated: true, completion: nil)

    }

    
    @IBAction func addPin(sender: AnyObject) {
        
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("InfoPostingViewController")
        self.presentViewController(controller!, animated: true, completion: nil)
        
    }

    
    //MARK: UITableView data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ParseClient.sharedInstance().studentLocations.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Casting to custom cell
        let cell = tableView.dequeueReusableCellWithIdentifier("studentCell", forIndexPath: indexPath) as! StudentTableViewCell
        
        let student = ParseClient.sharedInstance().studentLocations[indexPath.row]
        
        cell.studentLabel!.text = "\(student.firstName) \(student.lastName)"
        cell.pinImage!.contentMode = UIViewContentMode.ScaleAspectFit
        
        return cell
    }
    
    
    // After user selected a row, it shows URL to user's default browser
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let student = ParseClient.sharedInstance().studentLocations[indexPath.row]
        
        // Check if URL is empty
        if ((student.mediaURL!) == "") {
            self.alert("Student's link is empty")
            return
        }

        
        if let url = NSURL(string: student.mediaURL!) {
            // if (url != nil)
            if UIApplication.sharedApplication().canOpenURL(url) {
                UIApplication.sharedApplication().openURL(url)

            }
        }
    }
    
    //MARK: Helper methods
    
    func getStudentData(){
        
        ParseClient.sharedInstance().getStudentLocation() { result, error in
            if let error = error {
                // Make alert view show up with error from the Parse Client
                self.alert("Parse Error - \(error.description)")
                return
            } else {
                ParseClient.sharedInstance().studentLocations = result!
                // Display the data
                self.studentLocationtableView.reloadData()
            }
        }
    }
    
    
    func alert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        // Add an action (button)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        
        // Show the alert
        self.presentViewController(alert, animated: true, completion: nil)
    }

    
}
