//
//  ParseConvenience.swift
//  onTheMap
//
//  Created by Stella Su on 11/7/15.
//  Copyright © 2015 Million Stars, LLC. All rights reserved.
//


import UIKit
import Foundation

// MARK: - PARSECLIENT (Convenient Resource Methods)

extension ParseClient {
    
    // MARK: GET Convenience Methods
    
    func getStudentLocation(completionHandler: (result: [StudentLocation]?, error: NSError?) -> Void) {
        
        // Specify parameters and method
        let parameters = [
            ParseClient.ParameterKeys.Limit: "\(100)",
            ParseClient.ParameterKeys.Skip: "\(0)",
            ParseClient.ParameterKeys.Order: "-updatedAt"
        ]
        
        let method : String = Methods.StudentLocation + "?"
        
        // Make the request
        taskForGetMethod(method, parameters: parameters) { (JSONResult, error) in
            
            // Send the desired value(s) to the completion handler
            if let error = error {
                print("taskForGetMethod - \(error.localizedDescription)")
                completionHandler(result: nil, error: error)
            
            }
            else {
                if let results = JSONResult.valueForKey(ParseClient.JSONResponseKeys.Results) as? [[String : AnyObject]] {
                    let locations = StudentLocation.locationsFromResults(results)
                    completionHandler(result: locations, error: nil)
                } else {
                    print("Error parsing getStudentLocation -- couldn't find results string in \(JSONResult)")
                    completionHandler(result: nil, error: NSError(domain: "getStudentLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey : "Could not parse - \(JSONResult)"]))
                }
            }
        }
    }
    
    // MARK: POST Convenience Methods
    
    func postToStudentLocation(location: StudentLocation, completionHandler: (result: String?, error: NSError?) -> Void)
    {
        // Specify method and HTTP body (if POST)
        let method : String = Methods.StudentLocation
        
        let jsonBody: [String : AnyObject] = [
            ParseClient.JSONBodyKeys.UniqueKey: location.uniqueKey,
            ParseClient.JSONBodyKeys.FirstName: location.firstName,
            ParseClient.JSONBodyKeys.LastName: location.lastName,
            ParseClient.JSONBodyKeys.MapString: location.mapString,
            ParseClient.JSONBodyKeys.MediaURL: location.mediaURL! as String,
            ParseClient.JSONBodyKeys.Latitude: location.latitude! as Double,
            ParseClient.JSONBodyKeys.Longitude: location.longitude! as Double
        ]
        
        // Make the request
        taskForPostMethod(method, jsonBody: jsonBody) { (JSONResult, error) in
            
            // Send the desired values to the completion handler
            if let error = error {
                print("Error from postToStudentLocation \(error.localizedDescription )")
                completionHandler(result: nil, error: error)
            } else {
                if let objectID = JSONResult.valueForKey(ParseClient.JSONResponseKeys.ObjectID) as? String {
                    if let createdAt = JSONResult.valueForKey(ParseClient.JSONResponseKeys.CreatedAt) as? String {
                        print("Student Location Posted \(objectID) \(createdAt)")
                        completionHandler(result: objectID, error: nil)
                    } else {
                        print("Error parsing postToStudentLocation -- couldn't find createdAt in json result")
                        completionHandler(result: nil, error: NSError(domain: "postToStudentLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "couldn't find createdAt key in result"]))
                    }
                } else {
                    print("Error parsing postToStudentLocation -- couldn't find objectID in json result")
                    completionHandler(result: nil, error: NSError(domain: "postToStudentLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "couldn't find objectID key in result"]))
                }
            }
        }
                }
        
    
}
