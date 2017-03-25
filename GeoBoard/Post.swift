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
    let dispName: String!
    let location: CLLocation!
    let timeRemainSeconds: Int!
    let postContent: String!
    
    init(info: NSDictionary) {
        userID = info["userID"] as! String
        dispName = info["dispName"] as! String
        let locationData = info["location"] as! NSDictionary
        timeRemainSeconds = info["timeRemainSeconds"] as! Int
        postContent = info["postContent"] as! String!
        
        let latitude = locationData["latitude"] as! CLLocationDegrees
        let longitude = locationData["longitude"] as! CLLocationDegrees
        let altitude = locationData["altitude"] as! CLLocationDistance
        let timestamp = locationData["timestamp"] as! Date
        location = CLLocation(coordinate: CLLocationCoordinate2DMake(latitude, longitude), altitude: altitude, horizontalAccuracy: kCLLocationAccuracyBest, verticalAccuracy: kCLLocationAccuracyBest, timestamp: timestamp)
    }
}
