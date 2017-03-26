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

    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        newPostTextView.delegate = self
        newPostTextView.text = "Write your post here..."
        newPostTextView.textColor = UIColor.lightGray
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func post() {
        let userID = UIDevice.current.identifierForVendor!.uuidString
        let dispName = "Test User"
        let location = ["latitude":locationManager.location?.coordinate.latitude,
                        "longitude":locationManager.location?.coordinate.longitude,
                        "altitude":locationManager.location?.altitude]
        let timeRemaining = 60 * 60
        guard let postContent = newPostTextView.text else {return}
        
        let json = ["userID":userID, "dispName":dispName, "location":location as NSDictionary,
                    "timeRemaining":timeRemaining, "postContent":postContent] as [String : Any]
        
        let isValid = JSONSerialization.isValidJSONObject(json)
        
        print(isValid)
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
    
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
