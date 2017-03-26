//
//  ViewController.swift
//  HDAugmentedRealityDemo
//
//  Created by Danijel Huis on 21/04/15.
//  Copyright (c) 2015 Danijel Huis. All rights reserved.
//

import UIKit
import CoreLocation

class AugmentedRealityViewController: ARViewController, ARDataSource, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var postAnnotations: [ARAnnotation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.startUpdatingLocation()
        }
        
        showARViewController()
    }
    
    /// Creates random annotations around predefined center point and presents ARViewController modally
    func showARViewController() {
        // Check if device has hardware needed for augmented reality
        let result = ARViewController.createCaptureSession()
        if result.error != nil {
            let message = result.error?.userInfo["description"] as? String
            let alertView = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in })
            alertView.addAction(defaultAction)
            self.present(alertView, animated: true, completion: nil)
            
            return
        }
        
        Posts.refresh(locationManager: locationManager, reloadDataMethod: getPostAnnotations)
   
        self.dataSource = self
        self.maxDistance = 0
        self.maxVisibleAnnotations = 100
        self.maxVerticalLevel = 5
        self.headingSmoothingFactor = 0.7
        self.trackingManager.userDistanceFilter = 0.1
        self.trackingManager.reloadDistanceFilter = 75
        self.setAnnotations(self.postAnnotations)
        self.uiOptions.debugEnabled = false
        self.uiOptions.closeButtonEnabled = false
        /*
        self.interfaceOrientationMask = .landscape
        self.onDidFailToFindLocation = {
            [weak self] elapsedSeconds, acquiredLocationBefore in
            
            self?.handleLocationFailure(elapsedSeconds: elapsedSeconds, acquiredLocationBefore: acquiredLocationBefore, arViewController: self)
        }
        */
    }
    
    /// This method is called by ARViewController, make sure to set dataSource property.
    func ar(_ arViewController: ARViewController, viewForAnnotation: ARAnnotation) -> ARAnnotationView {
        // Annotation views should be lightweight views, try to avoid xibs and autolayout all together.
        let annotationView = PostAnnotationView()
        annotationView.frame = CGRect(x: 0,y: 0,width: 150,height: 50)
        return annotationView;
    }
    
    @IBAction func refreshButtonWasPressed(_ sender: Any) {
        Posts.refresh(locationManager: locationManager, reloadDataMethod: getPostAnnotations)
    }
    
    fileprivate func getPostAnnotations() {
        var annotations: [ARAnnotation] = []
        
        for post in Posts.posts {
            let annotation = ARAnnotation()
            annotation.location = post.location
            annotation.title = post.postContent
            annotations.append(annotation)
        }
        print(annotations)
        self.postAnnotations = annotations
        self.setAnnotations(self.postAnnotations)
    }
    
    func handleLocationFailure(elapsedSeconds: TimeInterval, acquiredLocationBefore: Bool, arViewController: ARViewController?) {
        guard let arViewController = arViewController else { return }
        
        NSLog("Failed to find location after: \(elapsedSeconds) seconds, acquiredLocationBefore: \(acquiredLocationBefore)")
        
        // Example of handling location failure
        if elapsedSeconds >= 20 && !acquiredLocationBefore {
            // Stopped bcs we don't want multiple alerts
            arViewController.trackingManager.stopTracking()
            
            let alert = UIAlertController(title: "Problems", message: "Cannot find location, use Wi-Fi if possible!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Close", style: .cancel) {
                (action) in
                
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okAction)
            
            self.presentedViewController?.present(alert, animated: true, completion: nil)
        }
    }
}
