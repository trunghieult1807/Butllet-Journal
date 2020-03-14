//
//  LocationService.swift
//  Bullet Journal
//
//  Created by Apple on 3/13/20.
//  Copyright © 2020 Hieu Le. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

public class LocationService: NSObject, CLLocationManagerDelegate {
    
    public static var sharedInstance = LocationService()
    let locationManager: CLLocationManager
    var locationDataArray: [CLLocation]
    var useFilter: Bool
    
    
    override init() {
        locationManager = CLLocationManager()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = kCLDistanceFilterNone
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.allowsBackgroundLocationUpdates = false
        locationManager.pausesLocationUpdatesAutomatically = false
        locationDataArray = [CLLocation]()
        useFilter = true
        
        super.init()
        retrieveDataLocation()
        locationManager.delegate = self
        
        
    }
    
    func createDataLocation(name: CLLocation) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Map", in: managedContext)!
        let coordinate = NSManagedObject(entity: entity, insertInto: managedContext)
        coordinate.setValue(name.coordinate.latitude, forKeyPath: "latitude")
        coordinate.setValue(name.coordinate.longitude, forKeyPath: "longtitude")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func retrieveDataLocation() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Map")
        do {
            let result = try managedContext.fetch(fetchRequest)
            for coordinate in result as! [NSManagedObject] {
                let longtitude = coordinate.value(forKey: "longtitude") as! Double
                let latitude = coordinate.value(forKey: "latitude") as! Double
                let location = CLLocation(latitude: latitude, longitude: longtitude)
                locationDataArray.append(location)
            }
        } catch {
            print("Failed")
        }
    }
    
    
    func startUpdatingLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        } else {
            //tell view controllers to show an alert
            showTurnOnLocationServiceAlert()
        }
    }
    
    
    //MARK: CLLocationManagerDelegate protocol methods
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation] = []) {
        // var isFarEnough: Bool = false
        if let newLocation = locations.last {
            var locationAdded: Bool
            if useFilter {
                locationAdded = filterAndAddLocation(newLocation)
            } else {
                checkToAppend(newLocation: newLocation)
                locationAdded = true
            }
            
            if locationAdded {
                notifiyDidUpdateLocation(newLocation: newLocation)
            }
            for x in locationDataArray {
                print("Hello: \(x.coordinate)")
            }
            
        }
    }
    
    func checkToAppend(newLocation: CLLocation) {
        var isFarEnough = true
        for x in locationDataArray {
            if newLocation.distance(from: x) < 20 {
                print(newLocation.distance(from: x))
                isFarEnough = false
            }
        }
        if isFarEnough {
            locationDataArray.append(newLocation)
            createDataLocation(name: newLocation)
        }
    }
    
    func filterAndAddLocation(_ location: CLLocation) -> Bool {
        let age = -location.timestamp.timeIntervalSinceNow
        
        if age > 10{
            print("Locaiton is old.")
            return false
        }
        
        if location.horizontalAccuracy < 0{
            print("Latitidue and longitude values are invalid.")
            return false
        }
        
        if location.horizontalAccuracy > 100{
            print("Accuracy is too low.")
            return false
        }
        
        print("Location quality is good enough.")
        //locationDataArray.append(location)
        checkToAppend(newLocation: location)
        return true
        
    }
    
    
    public func locationManager(_ manager: CLLocationManager,
                                didFailWithError error: Error) {
        if (error as NSError).domain == kCLErrorDomain && (error as NSError).code == CLError.Code.denied.rawValue {
            //User denied your app access to location information.
            showTurnOnLocationServiceAlert()
        }
    }
    
    public func locationManager(_ manager: CLLocationManager,
                                didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            //You can resume logging by calling startUpdatingLocation here
            startUpdatingLocation()
        }
    }
    
    func showTurnOnLocationServiceAlert() {
        NotificationCenter.default.post(name: Notification.Name(rawValue:"showTurnOnLocationServiceAlert"), object: nil)
    }
    
    func notifiyDidUpdateLocation(newLocation:CLLocation) {
        NotificationCenter.default.post(name: Notification.Name(rawValue:"didUpdateLocation"), object: nil, userInfo: ["location" : newLocation])
    }
}
