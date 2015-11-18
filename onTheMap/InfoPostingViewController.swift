//
//  InfoPostingViewController.swift
//  onTheMap
//
//  Created by Stella Su on 11/14/15.
//  Copyright © 2015 Million Stars, LLC. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class InfoPostingViewController: UIViewController {

    @IBOutlet weak var askForLocation: UILabel!
    @IBOutlet weak var newLocation: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var findOnTheMapButton: UIButton!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.hidden = true
        urlTextField.hidden = true
        
    }

    @IBAction func findOnTheMapClicked(sender: AnyObject) {
        
        newLocation.hidden = true
        findOnTheMapButton.hidden = true
        askForLocation.hidden = true
        
        // Show new text fileds to ask for the link
        submitButton.hidden = false
        urlTextField.hidden = false
        
        // Forward geocode the string
        let address = newLocation.text!
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                // If it fails, display an alert view
                print("**Error**", error)
                
            }
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                
                // Construct an anotation
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinates
                self.mapView.addAnnotation(annotation)
                
            }

        })
    
    }

    // Add new Student's info to the queue
    @IBAction func submitButtonClicked(sender: AnyObject) {
        
        // If URL not valid, handle error
        // *** Do something here
        
        // *** maybe try to get it from the app delegate?!
        let newStudentInfo = UdacityClient.sharedInstance
/*
       
        // Save new location data
        UdacityClient.getAuthenticatedUser(user, error) in
        if error != nil {
            print("error getting user: \(error)")
            return
            
        }
 */
        
        var newStudentLocation = StudentLocation()
        newStudentLocation.firstName = newStudentInfo.firstName!
        print(newStudentInfo.firstName!)
        
        // Posting new student location to Parse
        ParseClient.sharedInstance().postToStudentLocation(newStudentLocation, completionHandler: {
            (success, error) in
            if error != nil {
                print(error)
                return
            }
            // *** Do something here
            })
        
        
        
        
        // Going back to the map and table tabbed view
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("mapViewVC") as! UITabBarController
        self.presentViewController(controller, animated: true, completion: nil)

        
    }
  
    @IBAction func cancelButtonClicked(sender: AnyObject) {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("mapViewVC") as! UITabBarController
        self.presentViewController(controller, animated: true, completion: nil)
        
    }

}
