// Constants.swift
// Centralized app‐wide constants.

import Foundation

enum Constants {
    /// The scheme, host, and base path for your API.
    static let apiScheme = "https"
    static let apiHost   = "api.crowdsearch.app"
    static let apiBasePath = "/api"
    static var baseURL: String { "\(apiScheme)://\(apiHost)" }
    
    /// Default map center (CWRU campus) and zoom spans.
    static let campusCenterLatitude  = 41.507421
    static let campusCenterLongitude = -81.607245
    static let campusLatitudeDelta   = 0.01
    static let campusLongitudeDelta  = 0.015
}

