import SwiftUI
import AuthenticationServices

struct AuthView: View {
    var isDebugMode: Bool

    var body: some View {
        VStack {
            if isDebugMode {
                SignInWithDevEmail
            } else {
                appleSignInButton
            }
        }.onAppear {
            print("isDebugMode:", isDebugMode)
            print("Build Configuration:", Config.buildConfiguration)
        }
    }
    

    private var SignInWithDevEmail: some View {
        Button("Sign In with dev email") {
            Task {
                do {
                    let user = try await SupabaseManager.shared.signInWithDevEmail()
                    print("Signed in as \(user.uid)")
                } catch {
                    print("Development sign-in failed: \(error.localizedDescription)")
                }
            }
        }
        .frame(height: 44)
        .frame(maxWidth: .infinity)
        .background(Color.black)
        .foregroundColor(.white)
        .cornerRadius(10)
        .font(.system(size: 17, weight: .semibold))
        .padding()
    }

    private var appleSignInButton: some View {
        SignInWithAppleButton(
            .signIn,
            onRequest: { request in
                request.requestedScopes = [.fullName, .email]
            },
            onCompletion: { result in
                switch result {
                case .success(let auth):
                    Task {
                        do {
                            let user = try await SupabaseManager.shared.signInWithApple(authorization: auth)
                            print("Signed in as \(user.uid)")
                        } catch {
                            print("Authentication failed: \(error.localizedDescription)")
                        }
                    }
                case .failure(let error):
                    print("Authentication error: \(error.localizedDescription)")
                }
            }
        )
        .signInWithAppleButtonStyle(.black)
        .frame(height: 44)
        .padding()
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        return Group {
            AuthView(isDebugMode: true)
                .previewDisplayName("Debug Version")

            AuthView(isDebugMode: false)
                .previewDisplayName("Release Version")
        }
    }
}
