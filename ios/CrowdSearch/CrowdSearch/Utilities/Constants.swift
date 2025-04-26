// Utilities/Constants.swift
// Centralized constants for CrowdSearch.

import Foundation
import CoreLocation

enum Constants {
    private static let info = Bundle.main.infoDictionary

    // API connection constants
    static var apiHost: String {
        info?["API_BASE_HOST"] as? String ?? "127.0.0.1"
    }

    static var apiPort: String {
        info?["API_BASE_PORT"] as? String ?? "5000"
    }

    static var baseURL: String {
        "http://\(apiHost):\(apiPort)"
    }

    static var apiKey: String {
        info?["API_KEY"] as? String ?? ""
    }

    // Campus constants
    static let campusCenterLatitude: CLLocationDegrees = 41.507421
    static let campusCenterLongitude: CLLocationDegrees = -81.607245
    static let campusLatitudeDelta: CLLocationDegrees = 0.01
    static let campusLongitudeDelta: CLLocationDegrees = 0.015

    /// Convenience computed property for the default map center coordinate.
    static var campusCenterCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: campusCenterLatitude,
            longitude: campusCenterLongitude
        )
    }
}
