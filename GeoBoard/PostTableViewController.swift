//
//  PostTableViewController.swift
//  GeoBoard
//
//  Created by Robbie Dozier on 3/25/17.
//  Copyright © 2017 HuskyDev. All rights reserved.
//

import UIKit
import CoreLocation

class PostTableViewController: UITableViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.startUpdatingLocation()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "DefaultBackground"))
        self.tableView.backgroundView = imageView
        imageView.contentMode = .scaleAspectFill
        imageView.contentScaleFactor = 1.5
        addParallaxToView(vw: imageView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Posts.refresh(locationManager: locationManager, reloadDataMethod: self.tableView.reloadData)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Posts.posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noARTableCell", for: indexPath) as! PostTableViewCell
        let post = Posts.posts[indexPath.row]
        cell.displayNameLabel.text = post.dispName
        cell.latitudeLabel.text = String(format: "%.1f", post.location.coordinate.latitude)
        cell.longitudeLabel.text = String(format: "%.1f", post.location.coordinate.longitude)
        cell.altitudeLabel.text = String(format: "%.1f", post.location.altitude)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy h:mm"
        cell.timeStampLabel.text = dateFormatter.string(from: post.location.timestamp)
        cell.timeRemainingLabel.text = String(post.timeRemaining)
        cell.postContentTextView.text = post.postContent
        return cell
    }
    
    @IBAction func tableRefresh(_ sender: Any) {
        Posts.refresh(locationManager: locationManager, reloadDataMethod: self.tableView.reloadData)
    }
    
    func addParallaxToView(vw: UIView) {
        let amount = 20
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMakeNewPost" {
            let hapticGenerator = UINotificationFeedbackGenerator()
            hapticGenerator.notificationOccurred(.success)
        }
    }

}
