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
    var streakTrack: String = "0"
    // var twentyFour = Date().addingTimeInterval(-24*60*60)
    var thirtySix = Date().addingTimeInterval(-36*60*60)
    var then = Date()
    var nowStore = Date()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Streak
        
        do {
            // Load data
            retrieveDataStreak()
            retrieveDataLastAccess()
            // Debug
            print("then: \(then)")
            print("now: \(nowStore)")
            //print("twentyFour: \(twentyFour)")
            print("thirtySix: \(thirtySix)")
            // Implementation for streak
            if then >= nowStore {
                createDataLastAccess(name: nowStore)
            }
            if isNewDay(_now: nowStore, _then: then) {
                streakIncrease()
                createDataLastAccess(name: nowStore)
            }
            else if then <= thirtySix {
                streakTrack = "0"
            }
            // Díplay and save streak
            streakCountLabel.text = streakTrack
            createDataStreak(name: streakTrack)
            createDataLastAccess(name: nowStore)
        }
    
        //MARK: 
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
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
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
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        journalsButton.alpha = 1
        
    }
    
    // MARK: Implement core data
    
    func createDataStreak(name: String) {
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
    
    func retrieveDataStreak() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        do {
            let result = try managedContext.fetch(fetchRequest)
            let temp = result as! [NSManagedObject]
            if temp.last?.value(forKey: "streak") != nil {
                print(temp.last?.value(forKey: "streak") as! String)//delete
                streakTrack = temp.last?.value(forKey: "streak") as! String
            }
            else {
                streakTrack = "0"
            }
            //}
        } catch {
            print("Failed")
        }
    }
    
    func createDataLastAccess(name: Date) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)!
        let lastAccess = NSManagedObject(entity: entity, insertInto: managedContext)
        lastAccess.setValue(name, forKeyPath: "lastAccess")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func retrieveDataLastAccess() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                if data.value(forKey: "lastAccess") != nil {
                    then = data.value(forKey: "lastAccess") as! Date
                    print(data.value(forKey: "lastAccess") as! Date)//delete
                }
            }
        } catch {
            print("Failed")
        }
    }
    
    func streakIncrease() {
        let temp = Int(streakTrack)! + 1
        streakTrack = String(temp)
    }
    
    func getDay(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: date)
    }
    
    func isNewDay(_now: Date, _then: Date) -> Bool {
        return Int(getDay(date: _now))! - Int(getDay(date: _then))! == 1
    }
    
}

