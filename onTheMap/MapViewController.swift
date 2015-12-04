//
//  MapViewController.swift
//  onTheMap
//
//  Created by Stella Su on 11/5/15.
//  Copyright © 2015 Million Stars, LLC. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var locationsSet = false
    let emptyURLSubtitleText = "Student has not entered an URL"
    
    //MARK: Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Set the map view delegate
        mapView.delegate = self
        
        // Set the locations on the map
        getStudentLocations()
        
        activityIndicator.hidden = true

    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        // Only set the pins if the locations has already been set
        if(locationsSet)
        {
            setPinsOnMap()
        }
    }
    
    //MARK: Tab Bar Buttons
    @IBAction func logoutClicked(sender: AnyObject) {
        UdacityClient.sharedInstance.logoutSession()
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("loginView")
        self.presentViewController(controller!, animated: true, completion: nil)
        

    }

    
    @IBAction func addPin(sender: AnyObject) {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("InfoPostingViewController")
        self.presentViewController(controller!, animated: true, completion: nil)
    }

    
    @IBAction func refreshButtonClicked(sender: AnyObject) {
        getStudentLocations()
    }
    
    //MARK: Map Behavior
    
    func getStudentLocations() {
        
        ParseClient.sharedInstance().getStudentLocation() { result, error in
            
            if error != nil {
                // Displays an alert if the download fails
                self.alert("\(error!.localizedDescription)")
            } else {
                print("Successfully getting students info!")
                StudentLocation.sharedInstance.studentLocations = result!
                self.locationsSet = true
                self.setPinsOnMap()
            }
        }
    }
    
    // Showing a pin for each student on the map view
    func setPinsOnMap() {
        dispatch_async(dispatch_get_main_queue(), {
            
            // First remove annotation currently showing on the map view
            self.mapView.removeAnnotations(self.mapView.annotations)
            
            var annotations = [MKPointAnnotation]()
            
            // Get data for every student
            for student in StudentLocation.sharedInstance.studentLocations
            {
                let firstName = student.firstName
                let lastName = student.lastName
                
                var mediaURL = ""
                if(student.mediaURL != nil) {
                    mediaURL = student.mediaURL!
                }
                else {
                    mediaURL = self.emptyURLSubtitleText
                }
                
                let latitude = CLLocationDegrees(student.latitude!)
                let longitude = CLLocationDegrees(student.longitude!)
                let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                _ = student.uniqueKey
                
                // Construct an anotation
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinates
                annotation.title = "\(firstName) \(lastName)"
                annotation.subtitle = mediaURL
                
                // Add each single annotation to the array
                annotations.append(annotation)
            }
            
            // Start the activity indicator
            self.activityIndicator.hidden = false
            self.activityIndicator.startAnimating()


            // Add the annotation to the map veiw
            self.mapView.addAnnotations(annotations)
            
            // Delay activity indicator so the user can see it
            let delay = 0.5 * Double(NSEC_PER_SEC)
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue()) {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidesWhenStopped = true
            }

        })
    }
    
    //MARK: MKMapViewDelegate functions that allow you to click on URLs in the pin views on the map
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID) as? MKPinAnnotationView
        
        if(pinView == nil) {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
  
    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if(annotationView.annotation!.subtitle! != emptyURLSubtitleText) {
            if(control == annotationView.rightCalloutAccessoryView) {
                let urlString = annotationView.annotation!.subtitle!
                
                if(verifyURL(urlString)) {
                    // Open student's link to their default browser if it is valid
                    UIApplication.sharedApplication().openURL(NSURL(string: urlString!)!)
                }
                else {
                    // If the url is not valid, show an alert view
                    alert("Student's URL is invalid")
                }
            }
        }
    }
    
    // MARK: Helpers
 
    // Reference: http://stackoverflow.com/questions/28079123/how-to-check-validity-of-url-in-swift
    func verifyURL(urlString: String?) -> Bool {
        // Check for nil
        if let urlString = urlString     {
            if let url = NSURL(string: urlString) {
            return UIApplication.sharedApplication().canOpenURL(url)
            }
        }
            return false
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

    
}




