//
//  ViewController.swift
//  MyTrackLocation
//
//  Created by Agus Adi Pranata on 10/07/20.
//  Copyright © 2020 gusadi. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController {

    
    @IBOutlet weak var mapView: MKMapView!
    
    private var locations: [MKPointAnnotation] = []
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.allowsBackgroundLocationUpdates = true
        
        return manager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func switchPressed(_ sender: UISwitch) {
        if sender.isOn {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.stopUpdatingLocation()
        }
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let mostRecentLocation = locations.last else {return}
        
        let annotationToAdd = MKPointAnnotation()
        annotationToAdd.coordinate = mostRecentLocation.coordinate
        
        self.locations.append(annotationToAdd)
        
        while self.locations.count > 50 {
            if let annotationToRemove = self.locations.first {
                self.locations.remove(at: 0)
                mapView.removeAnnotation(annotationToRemove)
            }
        }
        
        if UIApplication.shared.applicationState == .active {
            mapView.showAnnotations(self.locations, animated: true)
        } else {
            print("Aplikasi dalam background state. Lokasi baru saat ini ", mostRecentLocation)
        }
    }
}

