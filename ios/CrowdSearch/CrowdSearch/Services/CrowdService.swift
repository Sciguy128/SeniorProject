//
//  CrowdService.swift
//  CrowdSearch
//
//  Created by Ryan Lin on 4/4/25.
//

// ios/CrowdSearch/Services/CrowdService.swift
// Handles fetching crowd‐level data from your Flask backend.

import Foundation

@Observable
class CrowdService {
    static let shared = CrowdService()
    private let baseURL = "http://localhost:5000"

    func fetchCrowds() async throws -> [Crowd] {
        guard let url = URL(string: "\(baseURL)/api/crowds") else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        // Optional: Validate HTTP status
        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            throw URLError(.badServerResponse)
        }

        let decoded = try JSONDecoder().decode([Crowd].self, from: data)

        print("✅ Successfully fetched crowds:")
        for crowd in decoded {
            print("- Location: \(crowd.name), Crowd Level: \(crowd.crowd_level)")
        }

        return decoded
    }
}

