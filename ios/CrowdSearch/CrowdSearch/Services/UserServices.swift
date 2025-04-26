import Foundation

struct UserRequest: Codable {
    let id: String
    let name: String
    let email: String
}

struct UserDeleteRequest: Codable {
    let id: String
}

class UsersService {
    static let shared = UsersService()
    private init() {}

    func addUser(_ user: UserRequest) async throws {
        guard let url = URL(string: "\(Constants.baseURL)/api/users/add") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"  // 👈 SET IT EXPLICITLY
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if !Constants.apiKey.isEmpty {
            request.addValue(Constants.apiKey, forHTTPHeaderField: "x-api-key")
        }
        request.httpBody = try JSONEncoder().encode(user)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        if !(200...299).contains(httpResponse.statusCode) {
            if let errorResponse = try? JSONDecoder()
                .decode([String: String].self, from: data),
               let message = errorResponse["error"] {
                throw NSError(domain: "UsersService", code: httpResponse.statusCode, userInfo: [
                    NSLocalizedDescriptionKey: message
                ])
            } else {
                throw URLError(.badServerResponse)
            }
        }
    }

    func deleteUser(_ userId: String) async throws {
        guard let url = URL(string: "\(Constants.baseURL)/api/users/delete") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"  // 👈 SET IT EXPLICITLY
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if !Constants.apiKey.isEmpty {
            request.addValue(Constants.apiKey, forHTTPHeaderField: "x-api-key")
        }
        request.httpBody = try JSONEncoder().encode(UserDeleteRequest(id: userId))

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }
}

