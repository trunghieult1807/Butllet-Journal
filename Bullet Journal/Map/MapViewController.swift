//
//  MapViewController.swift
//  Bullet Journal
//
//  Created by Apple on 3/13/20.
//  Copyright © 2020 Hieu Le. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        
    }
    
    func setupMap() {
        mapView.addAnnotations(LocationService.sharedInstance.locationDataArray as! [MKAnnotation])
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: (LocationService.sharedInstance.locationManager.location?.coordinate.latitude)!, longitude: (LocationService.sharedInstance.locationManager.location?.coordinate.longitude)!)
        mapView.addAnnotation(annotation)
        
        
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 1000000, longitudinalMeters: 1000000)
        mapView.setRegion(region, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            self.mapView.setRegion(region, animated: true)
        }
        view.addSubview(mapView)
        
    }
    
}
