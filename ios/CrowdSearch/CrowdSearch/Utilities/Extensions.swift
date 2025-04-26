// Extensions.swift
// Helper extensions and global utility functions.

import SwiftUI

/// Converts a crowd level (0–10) into a gradient color from light blue (low) to red (high).
func crowdColor(for level: Int) -> Color {
    let clamped = min(max(level, 0), 10)
    let ratio = Double(clamped) / 10.0
    let red   = ratio
    let green = 0.5 * (1.0 - ratio)
    let blue  = 1.0 - ratio
    return Color(red: red, green: green, blue: blue)
}

extension URLRequest {
    /// Builds a JSON POST request to the given path under the app’s baseURL.
    static func postJSON(to path: String, body: Data) -> URLRequest? {
        guard let url = URL(string: Constants.baseURL + path) else { return nil }
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = body
        return req
    }
}
