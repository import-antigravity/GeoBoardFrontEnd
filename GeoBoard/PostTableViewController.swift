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
    let baseURL = URL(string: "http://192.241.134.224")!
    var posts: [Post] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        refresh()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noARTableCell", for: indexPath)

        // Configure the cell...

        return cell
    }
    
    @IBAction func refreshButtonWasPressed(_ sender: Any) {
        refresh()
    }
    
    func refresh() {
        // Placeholder URL Session
        let lat = (locationManager.location?.coordinate.latitude)! as Double
        let long = (locationManager.location?.coordinate.longitude)! as Double
        print(lat)
        print(long)
        
        var request = URLRequest(url: baseURL.appendingPathComponent("getposts").appendingPathComponent(String(format: "%f", lat)).appendingPathComponent(String(format: "%f", long)))
        request.httpMethod = "GET"
        let session = URLSession.shared
        
        session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if error == nil {
                    guard let json = try! JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary else {
                        return
                    }
                    let posts = json["posts"] as! NSArray
                    print(posts)
                    self.posts = []
                    for post in posts {
                        print("post:")
                        if let jsonPost = post as? NSDictionary {
                            self.posts.append(Post(info: jsonPost))
                        } else {
                            print("nope, CHUCK TESTA")
                        }
                    }
                }
                else {
                    print(error!)
                }
            }
        }.resume()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
