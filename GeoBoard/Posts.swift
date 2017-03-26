//
//  Posts.swift
//  GeoBoard
//
//  Created by Robbie Dozier on 3/26/17.
//  Copyright © 2017 HuskyDev. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class Posts {
    static var posts: [Post] = []
    
    static func refresh(locationManager: CLLocationManager, reloadDataMethod: @escaping () -> Void) {
        // Placeholder URL Session
        let lat = (locationManager.location?.coordinate.latitude)! as Double
        let long = (locationManager.location?.coordinate.longitude)! as Double
        
        var request = URLRequest(url: GlobalVariables.baseURL.appendingPathComponent("getposts").appendingPathComponent(String(format: "%f", lat)).appendingPathComponent(String(format: "%f", long)))
        request.httpMethod = "GET"
        let session = URLSession.shared
        
        session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if error == nil {
                    guard let json = try! JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary else {
                        return
                    }
                    let posts = json["posts"] as! NSArray
                    Posts.posts = []
                    for post in posts {
                        if let jsonPost = post as? NSDictionary {
                            let newPost = Post(info: jsonPost)
                            Posts.posts.append(newPost)
                        } else {
                            print("nope, CHUCK TESTA")
                        }
                    }
                }
                else {
                    print(error!)
                }
                reloadDataMethod()
            }
            }.resume()
        
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
}
