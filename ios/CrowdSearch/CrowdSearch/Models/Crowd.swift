// ios/CrowdSearch/Models/Crowd.swift
// Codable model for crowd‐level data returned by the backend.

import Foundation

/// Mirrors the JSON structure returned by GET /api/crowds.
struct Crowd: Codable, Identifiable {
    var id: UUID { UUID() }
    let name: String
    let crowd_level: Int
}
