//
//  Animations.swift
//  Bullet Journal
//
//  Created by Apple on 3/11/20.
//  Copyright © 2020 Hieu Le. All rights reserved.
//

import UIKit


func MoveAnimationNext(Label: UILabel) {
    let positionAnimation = CABasicAnimation(keyPath: "position")
    positionAnimation.fromValue = NSValue(cgPoint: CGPoint(x: Label.center.x + 70, y: Label.center.y))
    positionAnimation.toValue = NSValue(cgPoint: CGPoint(x: Label.center.x, y: Label.center.y))
    positionAnimation.duration = 0.5
    
    
    
    let fadeAnimation = CABasicAnimation(keyPath: "opacity")
    fadeAnimation.fromValue = 0
    fadeAnimation.toValue = 1
    fadeAnimation.duration = 0.5
    
    Label.layer.add(positionAnimation, forKey: nil)
    Label.layer.add(fadeAnimation, forKey: nil)
}

func MoveAnimationBack(Label: UILabel) {
    let positionAnimation = CABasicAnimation(keyPath: "position")
    positionAnimation.fromValue = NSValue(cgPoint: CGPoint(x: Label.center.x - 70, y: Label.center.y))
    positionAnimation.toValue = NSValue(cgPoint: CGPoint(x: Label.center.x, y: Label.center.y))
    positionAnimation.duration = 0.5
    
    
    
    let fadeAnimation = CABasicAnimation(keyPath: "opacity")
    fadeAnimation.fromValue = 0
    fadeAnimation.toValue = 1
    fadeAnimation.duration = 0.5
    
    Label.layer.add(positionAnimation, forKey: nil)
    Label.layer.add(fadeAnimation, forKey: nil)
}
