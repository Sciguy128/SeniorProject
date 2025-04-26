//
//  HourlyForecast.swift
//  CrowdSearch
//
//  Created by Ryan Lin on 4/26/25.
//

import Foundation

/// Represents one forecast data point.
struct HourlyForecast: Identifiable {
    var id = UUID()
    let hour: Int    // 0-23
    let value: Double
}
