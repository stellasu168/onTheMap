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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var newLongitude: Double? = nil
    var newLatitude: Double? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.hidden = true
        urlTextField.hidden = true
        activityIndicator.hidden = true
        
    }

    // MARK: Actions
    
    @IBAction func findOnTheMapClicked(sender: AnyObject) {
        
        newLocation.hidden = true
        findOnTheMapButton.hidden = true
        askForLocation.hidden = true
        activityIndicator.hidden = false
        
        // Show new text fileds to ask for the link
        submitButton.hidden = false
        urlTextField.hidden = false
        
        // Start the activity indicator
        activityIndicator.startAnimating()
        
        // Forward geocode the string
        let address = newLocation.text!
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if(error != nil) {
                // If geocoding fails, display an alert view
                self.alert("Geocoding Error - \(error?.description)")
                
            }
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                let longitude = CLLocationDegrees(coordinates.longitude)
                let latitude = CLLocationDegrees(coordinates.latitude)
                
                self.newLongitude = longitude
                self.newLatitude = latitude
                
                UdacityClient.sharedInstance.latitude = latitude
                UdacityClient.sharedInstance.longitude = longitude

                // Construct an anotation
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinates
                self.mapView.addAnnotation(annotation)
                
                
                // Zooms placemark into an appropriate region
                self.mapView.region = MKCoordinateRegionMake(coordinates, MKCoordinateSpanMake(0.2, 0.2))
                
                // Delay activity indicator so the user can see it
                let delay = 0.5 * Double(NSEC_PER_SEC)
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                dispatch_after(time, dispatch_get_main_queue()) {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidesWhenStopped = true
                }
                
            }
   
        })
    
    }

    // Add new Student's info to the queue
    @IBAction func submitButtonClicked(sender: AnyObject) {
        
        // Check if URL is empty
        if (urlTextField.text == "") {
            alert("Link cannot be empty")
            return
        }

        // If URL is invalid, show an alert view
        if(verifyURL(urlTextField.text!)) {
            alert("URL is invalid")
            return
        }
        
        /* Save new studnet location data --
        Encodes the data in JSON and posts to the RESTful service */
        var newStudentLocation = StudentLocation()
        newStudentLocation.firstName = UdacityClient.sharedInstance.firstName!
        newStudentLocation.lastName = UdacityClient.sharedInstance.lastName!
        newStudentLocation.uniqueKey = UdacityClient.sharedInstance.userID!
        newStudentLocation.mapString = newLocation.text!
        newStudentLocation.mediaURL = urlTextField.text!
        newStudentLocation.longitude = newLongitude
        newStudentLocation.latitude = newLatitude

        
        // Posting new student location to Parse
        ParseClient.sharedInstance().postToStudentLocation(newStudentLocation, completionHandler: {
            (success, error) in
            if error != nil {
                self.alert("Post fails - \(error?.description)")
                return
            }
            
            print("Post new student info successful")
            
            })
        
        // Going back to the map and table tabbed view
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("mapViewVC") as! UITabBarController
        self.presentViewController(controller, animated: true, completion: nil)
        
    }

    @IBAction func cancelButtonClicked(sender: AnyObject) {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("mapViewVC") as! UITabBarController
        self.presentViewController(controller, animated: true, completion: nil)
        
    }

    // MARK: Helpers

    func verifyURL(urlString: String?) -> Bool {
            if let url = NSURL(string: urlString!) {
                return UIApplication.sharedApplication().canOpenURL(url)
            } else {
                return false
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
