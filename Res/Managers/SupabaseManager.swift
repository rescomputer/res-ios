import Foundation
import Supabase

class SupabaseManager {
    static let shared = SupabaseManager()

    private(set) var client: SupabaseClient

    private init() {
        self.client = SupabaseClient(
            supabaseURL: URL(string: Config.SUPABASE_URL)!,
            supabaseKey: Config.SUPABASE_ANON_KEY
        )
    }
    
    struct VapiTokenResponse: Decodable {
        let jwt: String
    }
    func issueVapiToken() async throws -> String {
        do {
            let response: VapiTokenResponse = try await self.client.functions
                .invoke(
                    "issue-vapi-token"
                    
                )
            return response.jwt
        } catch {
            print("Error issuing VAPI token: \(error)")
            throw error
        }
    }
}
