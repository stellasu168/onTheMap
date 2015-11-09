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
    
/*    @IBAction func logoutClicked(sender: AnyObject) {
        Udacity.sharedInstance.logout()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
*/
    
    //MARK: UITableView data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ParseClient.sharedInstance().studentLocations.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("studentCell", forIndexPath: indexPath)
        let student = ParseClient.sharedInstance().studentLocations[indexPath.row]
        
        cell.textLabel!.text = "\(student.firstName) \(student.lastName)"
        
        // display the pins (somehow)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let student = ParseClient.sharedInstance().studentLocations[indexPath.row]
        
        if let url = NSURL(string: student.mediaURL!) {
            // if url != nil
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
                //self.showAlert("Parse Error", message: error.localizedDescription)
                print(error)
            } else {
                print("Successfully getting students info in a list view!")
                ParseClient.sharedInstance().studentLocations = result!
                
                // Display the data
                self.studentLocationtableView.reloadData()
            }
        }
    }
    
    
}
