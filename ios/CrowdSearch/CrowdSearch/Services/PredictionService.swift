import Foundation

class PredictionService {
    static let shared = PredictionService()

    private init() {}

    /// Our custom URLSession, with extra settings if needed.
    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 10    // 10 sec timeout
        config.timeoutIntervalForResource = 30   // 30 sec max download
        return URLSession(configuration: config)
    }()

    /// Fetches the forecast pivot for a specific location.
    func fetchForecast(for location: String) async throws -> [HourlyForecast] {
        guard let url = URL(string: "\(Constants.baseURL)/api/predict") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(Constants.apiKey, forHTTPHeaderField: "x-api-key")

        // DEBUG PRINT
        print("🌐 Fetching forecasts from:", url.absoluteString)

        // Run custom session task
        let (data, response) = try await session.data(for: request)

        // Check HTTP status
        if let http = response as? HTTPURLResponse {
            print("🌐 HTTP Status:", http.statusCode)
            if !(200...299).contains(http.statusCode) {
                throw URLError(.badServerResponse)
            }
        }

        // DEBUG RAW JSON
        if let raw = String(data: data, encoding: .utf8) {
            print("🌐 Raw /api/predict JSON:\n\(raw)")
        }

        // Parse pivot
        guard let pivot = try JSONSerialization.jsonObject(with: data) as? [[String]] else {
            throw URLError(.cannotParseResponse)
        }

        // Find matching location row
        guard let row = pivot.first(where: {
            $0.first?.trimmingCharacters(in: .whitespacesAndNewlines) == location
        }) else {
            print("❌ Location \(location) not found in pivot.")
            throw NSError(domain: "PredictionService", code: 404, userInfo: [
                NSLocalizedDescriptionKey: "No forecast found for location: \(location)"
            ])
        }

        print("✅ Found \(row.count - 1) forecast points for \(location).")

        let forecastValues = row.dropFirst().compactMap { Double($0) }

        return forecastValues.enumerated().map { idx, val in
            HourlyForecast(hour: idx, value: val)
        }
    }
}
