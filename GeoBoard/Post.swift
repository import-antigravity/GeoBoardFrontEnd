//
//  Post.swift
//  GeoBoard
//
//  Created by Robbie Dozier on 3/25/17.
//  Copyright © 2017 HuskyDev. All rights reserved.
//

import UIKit
import CoreLocation

class Post: NSObject {
    let userID: String!
    let postID: Int!
    let dispName: String!
    let location: CLLocation!
    let timeRemaining: Int!
    let postContent: String!
    
    init(info: NSDictionary) {
        userID = info["userID"] as! String
        postID = info["postID"] as! Int
        dispName = info["dispName"] as! String
        let locationData = info["location"] as! NSDictionary
        timeRemaining = info["timeReamaining"] as! Int
        postContent = info["postContent"] as! String
        
        let latitude = locationData["latitude"] as! CLLocationDegrees
        let longitude = locationData["longitude"] as! CLLocationDegrees
        let altitude = locationData["altitude"] as! CLLocationDistance
        let timestamp = locationData["timestamp"] as! Date
        location = CLLocation(coordinate: CLLocationCoordinate2DMake(latitude, longitude), altitude: altitude, horizontalAccuracy: kCLLocationAccuracyBest, verticalAccuracy: kCLLocationAccuracyBest, timestamp: timestamp)
    }
}
