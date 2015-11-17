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

    
    @IBOutlet weak var newLocation: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.navigationController?.toolbarHidden = false
        

        // Do any additional setup after loading the view.
    }

    
    @IBAction func findOnTheMapClicked(sender: AnyObject) {
        
        newLocation.hidden = true
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

  
    @IBAction func cancelButtonClicked(sender: AnyObject) {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("mapViewVC") as! UITabBarController
        self.presentViewController(controller, animated: true, completion: nil)
        
    }

}
