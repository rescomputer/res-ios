import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let apiBaseURL = "https://xsltilxucvfhkssumglu.supabase.co/functions/v1"

    func fetchJWTToken() async throws -> String {
        guard let url = URL(string: apiBaseURL + "/issue-vapi-token") else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let jwt = json["jwt"] as? String else {
            throw NSError(domain: "InvalidJWT", code: -1, userInfo: [NSLocalizedDescriptionKey: "JWT not found in response"])
        }
        return jwt
    }
}
