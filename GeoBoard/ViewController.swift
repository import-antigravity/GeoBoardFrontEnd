//
//  ViewController.swift
//  GeoBoard
//
//  Created by Robbie Dozier on 3/25/17.
//  Copyright © 2017 HuskyDev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var appTitle: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var newAccountButton: UIButton!
    @IBOutlet weak var BackgroundImageView: UIImageView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    var effect:UIVisualEffect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.black
        addParallaxToView(vw: BackgroundImageView)
        effect = blurView.effect
        blurView.effect = nil
        appTitle.alpha = 0
        emailField.alpha = 0
        passwordField.alpha = 0
        logInButton.alpha = 0
        newAccountButton.alpha = 0
        
        // Animate in
        UIView.animate(withDuration: 1) {
            self.blurView.effect = self.effect
            self.appTitle.alpha = 1
            self.emailField.alpha = 1
            self.passwordField.alpha = 1
            self.logInButton.alpha = 1
            self.newAccountButton.alpha = 1
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logInWasPressed(_ sender: Any) {
    }
    
    @IBAction func newAccountWasPressed(_ sender: Any) {
    }
    
    func addParallaxToView(vw: UIView) {
        let amount = 100
        
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

