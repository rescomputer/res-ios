import Foundation
import Supabase
import CryptoKit
import AuthenticationServices

class SupabaseManager {
    static let shared = SupabaseManager()
    
    private(set) var client: SupabaseClient
    private init() {
        self.client = SupabaseClient(
            supabaseURL: URL(string: Config.SUPABASE_URL)!,
            supabaseKey: Config.SUPABASE_ANON_KEY
        )
    }

    // *****************
    // ***** Auth ******
    // *****************
    struct AuthedUser {
        let uid: String
        let email: String?
    }

    func getCurrentSession() async throws -> AuthedUser {
        let session = try await client.auth.session
        print(session)
        print(session.user.id)
        return AuthedUser(uid: session.user.id.uuidString, email: session.user.email)
    }

    func signInWithDevEmail() async throws -> AuthedUser {
        let session = try await client.auth.signIn(email: Config.DEBUG_USER_EMAIL, password: Config.DEBUG_USER_PASSWORD)
        return AuthedUser(uid: session.user.id.uuidString, email: session.user.email)
    }

    func signInWithApple(authorization: ASAuthorization) async throws -> AuthedUser {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let tokenData = credential.identityToken,
              let idToken = String(data: tokenData, encoding: .utf8) else {
            throw NSError(domain: "SupabaseManagerErrorDomain", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Invalid Apple ID credentials"])
        }

        let nonce = generateNonceString()
        let session = try await client.auth.signInWithIdToken(credentials: .init(provider: .apple, idToken: idToken, nonce: sha256(nonce)))
        return AuthedUser(uid: session.user.id.uuidString, email: session.user.email)
    }

    private func generateNonceString(length: Int = 32) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }

    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        return hashedData.compactMap { String(format: "%02x", $0) }.joined()
    }

    func signOut() async throws {
        try await client.auth.signOut()
    }

    // *****************
    // *** FUNCTIONS ***
    // *****************
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
