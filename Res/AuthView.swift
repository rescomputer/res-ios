import SwiftUI
import AuthenticationServices

struct AuthView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        SignInWithAppleButton { request in
            request.requestedScopes = [.email, .fullName]
        } onCompletion: { result in
            Task {
                do {
                    guard let credential = try result.get().credential as? ASAuthorizationAppleIDCredential else {
                        return
                    }

                    guard let idToken = credential.identityToken.flatMap({ String(data: $0, encoding: .utf8) }) else {
                        return
                    }

                    // Perform Supabase sign-in
                    try await SupabaseService.shared.client.auth.signInWithIdToken(
                        credentials: .init(
                            provider: .apple,
                            idToken: idToken
                        )
                    )

                    // Update the authentication state
                    authViewModel.isAuthenticated = true
                } catch {
                    print("Authentication Error: \(error)")
                }
            }
        }
        .fixedSize()
    }
}
