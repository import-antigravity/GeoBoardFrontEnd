//
//  NewPostViewController.swift
//  GeoBoard
//
//  Created by Robbie Dozier on 3/25/17.
//  Copyright © 2017 HuskyDev. All rights reserved.
//

import UIKit
import CoreLocation

class NewPostViewController: UIViewController, CLLocationManagerDelegate, UITextViewDelegate {
    @IBOutlet weak var newPostTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!

    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.startUpdatingLocation()
        }
        
        newPostTextView.delegate = self
        newPostTextView.text = "Write your post here..."
        newPostTextView.textColor = UIColor.lightGray
        
        addParallaxToView(vw: imageView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func post() {
        let userID = UIDevice.current.identifierForVendor!.uuidString
        let dispName = UIDevice.current.identifierForVendor!.uuidString
        let location = ["latitude":String(format: "%f", locationManager.location!.coordinate.latitude),
                        "longitude":String(format: "%f", locationManager.location!.coordinate.longitude),
                        "altitude":String(format: "%f", locationManager.location!.altitude),
                        "timestamp":String(Date().timeIntervalSince1970)]
        let timeRemaining = 60 * 60
        guard let postContent = newPostTextView.text else {return}
        
        let json = ["userID":userID as String, "dispName":dispName as String, "location":location as NSDictionary,
                    "timeRemaining":timeRemaining as Int, "postContent":postContent as String] as [String : Any]
        
        var request = URLRequest(url: GlobalVariables.baseURL.appendingPathComponent("newpost"))
        request.httpMethod = "POST"
        let session = URLSession.shared
        request.httpBody = try! JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted]) as Data
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("applocation/json", forHTTPHeaderField: "Accept")
        
        session.uploadTask(with: request, from: request.httpBody) { (data, response, error) in
            if error != nil {
                print(error!)
            } else {
                print("It should have worked???")
                print(request.httpBody ?? "Chuck Testa~")
            }
        }.resume()
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    @IBAction func dismissKeyboard() {
        newPostTextView.resignFirstResponder()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            newPostTextView.resignFirstResponder()
            post()
            return false
        } else {
            return true
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = nil
        textView.textColor = UIColor.black
    }
    
    func addParallaxToView(vw: UIView) {
        let amount = 80
        
        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -amount
        horizontal.maximumRelativeValue = amount
        
        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -amount
        vertical.maximumRelativeValue = amount
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontal, vertical]
        vw.addMotionEffect(group)
    }
}
