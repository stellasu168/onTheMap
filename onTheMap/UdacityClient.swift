//
//  UdacityClient.swift
//  onTheMap
//
//  Created by Stella Su on 11/9/15.
//  Copyright © 2015 Million Stars, LLC. All rights reserved.
//

import Foundation

class UdacityClient: NSObject {

    // Shared session
    var session: NSURLSession
    
    
    // Authentication data
    var sessionID: String? = nil
    var userID: String? = nil
    var loginError: String? = nil
    
    // User data
    var firstName: String? = nil
    var lastName: String? = nil
    var latitude: Double? = nil
    var longitude: Double? = nil
    var mediaURL: String? = nil
    var mapString: String? = nil

    
    // MARK: Initializers
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }

    // MARK: Get
    
    
    
}
