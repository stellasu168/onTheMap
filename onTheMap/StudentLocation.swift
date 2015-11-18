//
//  StudentLocation.swift
//  onTheMap
//
//  Created by Stella Su on 11/6/15.
//  Copyright © 2015 Million Stars, LLC. All rights reserved.
//

// MARK: - StudentLocation

struct StudentLocation {
    
    // MARK: Properties
    
    var firstName = ""
    var lastName = ""
    var latitude: Double? = nil
    var longitude: Double? = nil
    var mapString = ""
    var mediaURL: String? = nil
    var objectID = ""
    var uniqueKey = ""
    var createdAt = ""
    var updatedAt = ""
    
    // Construct a StudentLocation from a dictionary
    init() {}
    
    init(dictionary: [String : AnyObject]) {
        firstName = dictionary[ParseClient.JSONResponseKeys.FirstName] as! String
        lastName = dictionary[ParseClient.JSONResponseKeys.LastName] as! String
        latitude = dictionary[ParseClient.JSONResponseKeys.Latitude] as? Double
        longitude = dictionary[ParseClient.JSONResponseKeys.Longitude] as? Double
        mapString = dictionary[ParseClient.JSONResponseKeys.MapString] as! String
        mediaURL = dictionary[ParseClient.JSONResponseKeys.MediaURL] as? String
        objectID = dictionary[ParseClient.JSONResponseKeys.ObjectID] as! String
        uniqueKey = dictionary[ParseClient.JSONResponseKeys.UniqueKey] as! String
        createdAt = dictionary[ParseClient.JSONResponseKeys.CreatedAt] as! String
        updatedAt = dictionary[ParseClient.JSONResponseKeys.UpdatedAt] as! String
    }
    
    // Helper: Given an array of dictionaries, convert them to an array of StudentLocation objects
    static func locationsFromResults(results: [[String : AnyObject]]) -> [StudentLocation] {
        var studentLocations = [StudentLocation]()
        
        for result in results {
            studentLocations.append(StudentLocation(dictionary: result))
        }
        
        return studentLocations
    }

}
