//
//  JournalsList.swift
//  Bullet Journal
//
//  Created by Apple on 3/8/20.
//  Copyright © 2020 Hieu Le. All rights reserved.
//

import UIKit

class JournalList: UIViewController {
    
    @IBOutlet weak var leadingConstrain: NSLayoutConstraint!
    @IBOutlet weak var trailingConstrain: NSLayoutConstraint!
    @IBOutlet weak var widthHide: NSLayoutConstraint!
    @IBOutlet weak var journalsButton: UIButton!
    @IBOutlet weak var hideButton: UIButton!
    
    var isVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: Journals Menu
    @IBAction func journalsTapped(_ sender: Any) {
        leadingConstrain.constant = 280
        trailingConstrain.constant = -280
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }) { (animationComplete) in
            print("The animation is complete!")
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.widthHide.constant = self.view.frame.width - 280
            UIView.animate(withDuration: 0.05, delay: 0.0, options: .curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            }) { (animationComplete) in
                print("The animation is complete!")
            }
        }
        
        journalsButton.alpha = 0
        
    }
    @IBAction func hideButtonTapped(_ sender: Any) {
        leadingConstrain.constant = 0
        trailingConstrain.constant = 0
        UIView.animate(withDuration: 0.1, delay: 0.01, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }) { (animationComplete) in
            print("The animation is complete!")
        }
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.widthHide.constant = 0
            UIView.animate(withDuration: 0.05, delay: 0.0, options: .curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            }) { (animationComplete) in
                print("The animation is complete!")
            }
        }
        journalsButton.alpha = 1
        
    }
    
}
