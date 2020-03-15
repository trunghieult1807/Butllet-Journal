//
//  FirstVC.swift
//  Bullet Journal
//
//  Created by Apple on 3/8/20.
//  Copyright © 2020 Hieu Le. All rights reserved.
//

import UIKit
import CoreData

class FirstVC: UIViewController {
    var streakTrack: String = "0"
    //var twentyFour = Date().addingTimeInterval(-24*60*60)
    var thirtySix = Date().addingTimeInterval(-36*60*60)
    var then = Date()
    var nowStore = Date()
    
    
    @IBOutlet weak var streakLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
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
            streakLabel.text = streakTrack
            createDataStreak(name: streakTrack)
            createDataLastAccess(name: nowStore)
            // MARK: Date label
            getMonthAndYear()
        }
    }
    
    // MARK: Get time
    func getMonthAndYear() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let yearString = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "LLLL"
        let monthString = dateFormatter.string(from: date)
        timeLabel.text = monthString + ", " + yearString
    }
    
    
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
    
    // MARK: Camera
    @IBAction func camera(_ gesture: UITapGestureRecognizer) {
        
    }
    
}
