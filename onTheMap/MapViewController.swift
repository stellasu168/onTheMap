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
    
    var locationsSet = false
    let emptyURLSubtitleText = "Student has not entered a URL"
    
    //MARK --- Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Set the map view delegate
        mapView.delegate = self

        
        // Set the locations on the map
        setLocations()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        // only set the pins if the locations has already been set
        if(locationsSet)
        {
            setPinsOnMap()
        }
    }
    
    //MARK --- Tab Bar Buttons
    
/*    func logout(sender: AnyObject)
    {
        UdacityClient.sharedInstance().logoutOfSession() { result, error in
            
            if let error = error
            {
                //make alert view show up with error from the Udacity client
                self.showAlertController("Udacity Logout Error", message: error.localizedDescription)
            }
            else
            {
                print("Successfully logged out of Udacity session")
                
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
*/

/*    func addPin(sender: AnyObject)
    {
        //Grab the information posting VC from Storyboard
        let object:AnyObject = storyboard!.instantiateViewControllerWithIdentifier("InfoPostingViewController")
        
        let addPinVC = object as! InfoPostingViewController
        
        //Present the view controller
        presentViewController(addPinVC, animated: true, completion: nil)
    }
*/
    func refreshButtonClicked(sender: AnyObject)
    {
        setLocations()
    }
    
    //MARK --- Map Behavior
    
    func setLocations()
    {
        ParseClient.sharedInstance().getStudentLocation() { result, error in
            
            if let error = error
            {
                //make alert view show up with error from the Parse Client
                self.showAlertController("Parse Error", message: error.localizedDescription)
            }
            else
            {
                print("Successfully got student info!")
                
                ParseClient.sharedInstance().studentLocations = result!
                self.locationsSet = true
                self.setPinsOnMap()
            }
        }
    }
    
    func setPinsOnMap()
    {
        dispatch_async(dispatch_get_main_queue(), {
            
            //first remove annootations currently showing on the map view
            self.mapView.removeAnnotations(self.mapView.annotations)
            
            var annotations = [MKPointAnnotation]()
            
            //get the needed data for every student
            for student in ParseClient.sharedInstance().studentLocations
            {
                let firstName = student.firstName
                let lastName = student.lastName
                
                var mediaURL = ""
                if(student.mediaURL != nil)
                {
                    mediaURL = student.mediaURL!
                }
                else
                {
                    mediaURL = self.emptyURLSubtitleText
                }
                
                let latitude = CLLocationDegrees(student.latitude!)
                let longitude = CLLocationDegrees(student.longitude!)
                let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                _ = student.uniqueKey
                
                //construct an anotation
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinates
                annotation.title = "\(firstName) \(lastName)"
                annotation.subtitle = mediaURL
                
                //add each single annotation to the array
                annotations.append(annotation)
            }
            
            //add the annotations to the map veiw
            self.mapView.addAnnotations(annotations)
        })
    }
    
    //MARK -- MKMapViewDelegate functions that allow you to click on URLs in the pin views on the map
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?
    {
        let reuseID = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID) as? MKPinAnnotationView
        
        if(pinView == nil)
        {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else
        {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    {
        if(annotationView.annotation!.subtitle! != emptyURLSubtitleText)
        {
            if(control == annotationView.rightCalloutAccessoryView)
            {
                let urlString = annotationView.annotation!.subtitle!
                
                if(verifyURL(urlString))
                {
                    //open the url if valid
                    UIApplication.sharedApplication().openURL(NSURL(string: urlString!)!)
                }
                else
                {
                    //if the url is not valid, show an alert view
                    showAlertController("URL Lookup Failed", message: "The provided URL is not valid.")
                }
            }
        }
    }
    
    //MARK --- Helpers
    
    // learned how to verify urls from this website:
    //http://stackoverflow.com/questions/28079123/how-to-check-validity-of-url-in-swift
    func verifyURL(urlString: String?) -> Bool
    {
        if let urlString = urlString
        {
            if let url = NSURL(string: urlString)
            {
                return UIApplication.sharedApplication().canOpenURL(url)
            }
        }
        
        return false
    }
 
    func showAlertController(title: String, message: String)
    {
        dispatch_async(dispatch_get_main_queue(), {
            
            print("failure string from client: \(message)")
            
            let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alert.addAction(okAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
        })
    }

    
    
    
  

    
}
