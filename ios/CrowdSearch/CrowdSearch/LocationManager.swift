//
//  LocationManager.swift
//  CrowdSearch
//
//  Created by Ryan Lin on 4/4/25.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var isOnCampus = false

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.last?.coordinate else { return }
        userLocation = coordinate
        isOnCampus = isWithinCampusBounds(coordinate)
    }

    private func isWithinCampusBounds(_ coordinate: CLLocationCoordinate2D) -> Bool {
        // Define your bounding box around CWRU campus
        let latMin = 41.498
        let latMax = 41.515
        let lonMin = -81.614
        let lonMax = -81.602

        return (latMin...latMax).contains(coordinate.latitude) &&
               (lonMin...lonMax).contains(coordinate.longitude)
    }
}
