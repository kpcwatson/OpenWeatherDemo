//
//  AddCityViewController.swift
//  OpenWeatherDemo
//
//  Created by Kyle Watson on 7/7/17.
//  Copyright © 2017 Kyle Watson. All rights reserved.
//

import UIKit
import Foundation
import MapKit

class AddCityViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    fileprivate let pin = MKPointAnnotation()
    
    private let defaults = UserDefaults.standard
    private var locality: String?
    private var storedCities: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        storedCities = defaults.array(forKey: citiesKey) as? [String] ?? []
        
        mapView.showsUserLocation = true
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.distanceFilter = 1000.0
        locationManager.startUpdatingLocation()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let locality = locality {
            storedCities.append(locality)
            defaults.set(storedCities, forKey: citiesKey)
            defaults.synchronize()
        }
    }
    
    @IBAction func dropPin(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let point = sender.location(in: mapView)
            let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
            
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
                guard let strongSelf = self else {
                    return
                }
                
                guard let locality = placemarks?.first?.locality else {
                    Logger.error("locality is nil; error=\(String(describing: error))")
                    return
                }
                
                strongSelf.locality = locality
                
                strongSelf.mapView.removeAnnotation(strongSelf.pin)
                strongSelf.pin.coordinate = coordinate
                strongSelf.mapView.addAnnotation(strongSelf.pin)
            }
        }
    }
}

extension AddCityViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else {
            return
        }
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapView.setRegion(region, animated: true)
    }
}
