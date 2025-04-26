import Foundation

struct XPResponse: Codable {
    let xp: String
    let rank: String
}

class XPService {
    static let shared = XPService()
    private init() {}

    func getXP(id: String) async throws -> (xp: Int, rank: String) {
        guard let url = URL(string: "\(Constants.baseURL)/api/xp") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)  // <-- define the request properly
        request.httpMethod = "POST"          // <-- then set httpMethod on it
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if !Constants.apiKey.isEmpty {
            request.addValue(Constants.apiKey, forHTTPHeaderField: "x-api-key")
        }

        let body = try JSONEncoder().encode(["id": id])
        request.httpBody = body

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        if !(200...299).contains(httpResponse.statusCode) {
            if let errorDict = try? JSONDecoder()
                .decode([String: String].self, from: data),
               let errorMessage = errorDict["error"] {
                throw NSError(domain: "XPService", code: httpResponse.statusCode,
                              userInfo: [NSLocalizedDescriptionKey: errorMessage])
            }
            throw URLError(.badServerResponse)
        }

        let xpData = try JSONDecoder().decode(XPResponse.self, from: data)

        guard let xpInt = Int(xpData.xp) else {
            throw NSError(domain: "XPService", code: 0,
                          userInfo: [NSLocalizedDescriptionKey: "Invalid XP value"])
        }

        return (xpInt, xpData.rank)
    }
}
