// ios/CrowdSearch/Models/CrowdLocation.swift
// Defines a map annotation with a crowd-level indicator.

import Foundation
import CoreLocation

/// Represents a point of interest on the map with its current crowd level.
struct CrowdLocation: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let crowdLevel: Int
}
