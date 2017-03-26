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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
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
        
        // Create random annotations around center point    //@TODO
        //FIXME: set your initial position here, this is used to generate random POIs
        let lat = (locationManager.location?.coordinate.latitude)! as Double
        let lon = (locationManager.location?.coordinate.longitude)! as Double
        let delta = 0.05
        let count = 50
        let dummyAnnotations = self.getDummyAnnotations(centerLatitude: lat, centerLongitude: lon, delta: delta, count: count)
   
        // Present ARViewController
        //let arViewController = ARViewController()
        //self.dataSource = self
//        arViewController.maxDistance = 0
//        arViewController.maxVisibleAnnotations = 100
//        arViewController.maxVerticalLevel = 5
//        arViewController.headingSmoothingFactor = 0.1
//        arViewController.trackingManager.userDistanceFilter = 25
//        arViewController.trackingManager.reloadDistanceFilter = 75
//        arViewController.setAnnotations(dummyAnnotations)
//        arViewController.uiOptions.debugEnabled = true
//        arViewController.uiOptions.closeButtonEnabled = true
//        //arViewController.interfaceOrientationMask = .landscape
//        arViewController.onDidFailToFindLocation = {
//            [weak self, weak arViewController] elapsedSeconds, acquiredLocationBefore in
//                
//            self?.handleLocationFailure(elapsedSeconds: elapsedSeconds, acquiredLocationBefore: acquiredLocationBefore, arViewController: arViewController)
//        }
//        self.navigationController?.pushViewController(arViewController, animated: true)
//        
        
        self.dataSource = self
        self.maxDistance = 0
        self.maxVisibleAnnotations = 100
        self.maxVerticalLevel = 5
        self.headingSmoothingFactor = 0.1
        self.trackingManager.userDistanceFilter = 25
        self.trackingManager.reloadDistanceFilter = 75
        self.setAnnotations(dummyAnnotations)
        self.uiOptions.debugEnabled = true
        self.uiOptions.closeButtonEnabled = true
        //arViewController.interfaceOrientationMask = .landscape
//        self.onDidFailToFindLocation = {
//            [weak self, weak arViewController] elapsedSeconds, acquiredLocationBefore in
//            
//            self?.handleLocationFailure(elapsedSeconds: elapsedSeconds, acquiredLocationBefore: acquiredLocationBefore, arViewController: arViewController)
//        }

    }
    
    /// This method is called by ARViewController, make sure to set dataSource property.
    func ar(_ arViewController: ARViewController, viewForAnnotation: ARAnnotation) -> ARAnnotationView {
        // Annotation views should be lightweight views, try to avoid xibs and autolayout all together.
        let annotationView = PostAnnotationView()
        annotationView.frame = CGRect(x: 0,y: 0,width: 150,height: 50)
        return annotationView;
    }
    
    fileprivate func getDummyAnnotations(centerLatitude: Double, centerLongitude: Double, delta: Double, count: Int) -> Array<ARAnnotation> {
        var annotations: [ARAnnotation] = []
        
        srand48(3)
        for i in stride(from: 0, to: count, by: 1) {
            let annotation = ARAnnotation()
            annotation.location = self.getRandomLocation(centerLatitude: centerLatitude, centerLongitude: centerLongitude, delta: delta)
            annotation.title = "POI \(i)"
            annotations.append(annotation)
        }
        return annotations
    }
    
    fileprivate func getRandomLocation(centerLatitude: Double, centerLongitude: Double, delta: Double) -> CLLocation {
        var lat = centerLatitude
        var lon = centerLongitude
        
        let latDelta = -(delta / 2) + drand48() * delta
        let lonDelta = -(delta / 2) + drand48() * delta
        lat = lat + latDelta
        lon = lon + lonDelta
        return CLLocation(latitude: lat, longitude: lon)
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
