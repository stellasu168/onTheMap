//
//  ParseConstants.swift
//  onTheMap
//
//  Created by Stella Su on 11/6/15.
//  Copyright © 2015 Million Stars, LLC. All rights reserved.
//


import Foundation

extension ParseClient {

    //MARK --- Constants
    struct Constants
    {
        //api keys
        static let ParseAppID : String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RestAPIKey : String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        //URLs
        static let BaseURLSecure : String = "https://api.parse.com/"
    }
    
    //MARK --- Methods
    struct Methods
    {
        static let StudentLocation : String = "1/classes/StudentLocation"
    }
    
    //MARK --- URL Keys
    
    
    //MARK --- Parameter Keys
    struct ParameterKeys
    {
        static let Limit = "limit"
        static let Skip = "skip"
        static let Order = "order"
        static let Where = "where"
        static let ObjectID = "objectId"
    }
    
    //MARK --- JSON Body Keys
    struct JSONBodyKeys
    {
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
    }
    
    //MARK --- JSON Response Keys
    struct JSONResponseKeys
    {
        static let Results = "results"
        
        //errors
        static let StatusMessage = "error"
        static let StatusCode = "status"
        
        //students
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let ObjectID = "objectId"
        static let UniqueKey = "uniqueKey"
        static let CreatedAt = "createdAt"
        static let UpdatedAt = "updatedAt"
    }
    
}


