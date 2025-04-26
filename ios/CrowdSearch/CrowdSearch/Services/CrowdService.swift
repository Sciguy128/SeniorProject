//
//  CrowdService.swift
//  CrowdSearch
//
//  Created by Ryan Lin on 4/4/25.
//

import Foundation


class CrowdService {
    static let shared = CrowdService()
    private let baseURL = "http://localhost:5000" // Backend URL

    func fetchCrowds() async throws -> [Crowd] {
        guard let url = URL(string: "\(baseURL)/api/crowds") else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        let decoded = try JSONDecoder().decode([Crowd].self, from: data)
        return decoded
    }
}

