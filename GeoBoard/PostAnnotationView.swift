//
//  TestAnnotationView.swift
//  HDAugmentedRealityDemo
//
//  Created by Danijel Huis on 30/04/15.
//  Copyright (c) 2015 Danijel Huis. All rights reserved.
//

import UIKit

open class PostAnnotationView: ARAnnotationView, UIGestureRecognizerDelegate
{
    open var titleLabel: UILabel?

    override open func didMoveToSuperview()
    {
        super.didMoveToSuperview()
        if self.titleLabel == nil
        {
            self.loadUi()
        }
    }
    
    func loadUi()
    {
        // Title label
        self.titleLabel?.removeFromSuperview()
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.numberOfLines = 5
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.darkGray
        self.addSubview(label)
        self.titleLabel = label
        
        /*
        // Gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PostAnnotationView.tapGesture))
        self.addGestureRecognizer(tapGesture)
        */
        
        // Other
        self.backgroundColor = UIColor.init(red: 0.4, green: 0.8, blue: 0.8, alpha: 0.4)
        self.layer.cornerRadius = 5
        
        if self.annotation != nil
        {
            self.bindUi()
        }
    }
    
    func layoutUi()
    {
        let buttonWidth: CGFloat = 40
        
        self.titleLabel?.frame = CGRect(x: 10, y: 0, width: self.frame.size.width - buttonWidth - 5, height: self.frame.size.height);
    }
    
    // This method is called whenever distance/azimuth is set
    override open func bindUi()
    {
        if let annotation = self.annotation, let title = annotation.title
        {
            let distance = annotation.distanceFromUser > 1000 ? String(format: "%.1fkm", annotation.distanceFromUser / 1000) : String(format:"%.0fm", annotation.distanceFromUser)
            
            let text = String(format: "%@\nAZ: %.0f°\nDST: %@", title, annotation.azimuth, distance)
            self.titleLabel?.text = text
        }
    }
    
    open override func layoutSubviews()
    {
        super.layoutSubviews()
        self.layoutUi()
    }
    /*
    open func tapGesture()
    {
        if let annotation = self.annotation
        {
            
        }
    }
    */


}
