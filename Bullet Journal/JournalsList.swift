//
//  JournalsList.swift
//  Bullet Journal
//
//  Created by Apple on 3/8/20.
//  Copyright © 2020 Hieu Le. All rights reserved.
//

import UIKit
import CoreData


class JournalList: UIViewController {
    
    @IBOutlet weak var leadingConstrain: NSLayoutConstraint!
    @IBOutlet weak var trailingConstrain: NSLayoutConstraint!
    @IBOutlet weak var widthHide: NSLayoutConstraint!
    @IBOutlet weak var journalsButton: UIButton!
    @IBOutlet weak var hideButton: UIButton!
    @IBOutlet weak var streakCountLabel: UILabel!
    
    
    var isVisible: Bool = false
    var streakTrack: String = "1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Load data
        retrieveData()
        
        // Is new day?
        NotificationCenter.default.addObserver(self, selector:#selector(self.calendarDayDidChange(_:)), name:NSNotification.Name.NSCalendarDayChanged, object:nil)
        

        streakCountLabel.text = streakTrack
        createData(name: streakTrack)
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
    // MARK: Implement core data
    func createData(name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)!
        let streak = NSManagedObject(entity: entity, insertInto: managedContext)
        streak.setValue(name, forKeyPath: "streak")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func retrieveData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "streak") as! String)//delete
                streakTrack = data.value(forKey: "streak") as! String
            }
        } catch {
            print("Failed")
        }
    }
    @objc private func calendarDayDidChange(_ notification : NSNotification) {
        let temp = Int(streakTrack)! + 1
        streakTrack = String(temp)
    }
    
    
}
