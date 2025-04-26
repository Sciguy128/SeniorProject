// ios/CrowdSearch/Services/ReportService.swift
// Submits user crowd reports to the Flask backend.

import Foundation

/// Payload for POST /api/report
struct ReportRequest: Codable {
    let user_id: String
    let location: String
    let crowd_level: Int
}

class ReportService {
    static let shared = ReportService()
    private init() {}

    /// Sends a new crowd report to /api/report.
    func submitReport(_ report: ReportRequest) async throws {
        // 1) Build URL
        guard let url = URL(string: "\(Constants.baseURL)/api/report") else {
            throw URLError(.badURL)
        }

        // 2) Encode body
        let bodyData = try JSONEncoder().encode(report)

        // 3) Build request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // API key header
        if !Constants.apiKey.isEmpty {
            request.addValue(Constants.apiKey, forHTTPHeaderField: "x-api-key")
        }
        request.httpBody = bodyData

        // 4) (Optional) Debug log
        #if DEBUG
        if let raw = String(data: bodyData, encoding: .utf8) {
            print("📝 Reporting payload:\n\(raw)")
        }
        print("📬 Sending POST to:", url.absoluteString)
        #endif

        // 5) Send
        let (data, response) = try await URLSession.shared.data(for: request)

        // 6) Check status code
        if let http = response as? HTTPURLResponse {
            #if DEBUG
            print("📬 Response status:", http.statusCode)
            if let text = String(data: data, encoding: .utf8) {
                print("📬 Response body:\n\(text)")
            }
            #endif
            guard (200...299).contains(http.statusCode) else {
                throw URLError(.badServerResponse)
            }
        }

        // 7) Optionally parse response JSON for confirmation
        //    e.g. {"message":"Location X updated successfully"}
        // let _ = try JSONDecoder().decode([String: String].self, from: data)
    }
}
