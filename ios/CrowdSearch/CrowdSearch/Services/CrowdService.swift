//
//  CrowdService.swift
//  CrowdSearch
//
//  Created by Ryan Lin on 4/4/25.
//

// ios/CrowdSearch/Services/CrowdService.swift
// Handles fetching crowd‐level data from your Flask backend.

import Foundation


class CrowdService {
    static let shared = CrowdService()
    private let baseURL = "http://localhost:5000" // Use your actual server URL

    func fetchCrowds() async throws -> [Crowd] {
        guard let url = URL(string: "\(baseURL)/api/crowds") else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        let decoded = try JSONDecoder().decode([Crowd].self, from: data)
        return decoded
    }
}
