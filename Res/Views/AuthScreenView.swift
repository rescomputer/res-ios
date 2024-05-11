import SwiftUI
import AuthenticationServices


import Combine

class AuthViewModel: ObservableObject {
    @Published var currentSessionUID: String?
    @Published var errorMessage: String?
    @Published var isFetchingSession = true

    init() {
        fetchCurrentSession()
    }
    
    func fetchCurrentSession() {
        Task {
            do {
                let session = try await SupabaseManager.shared.getCurrentSession()
                await MainActor.run {
                    self.isFetchingSession = false
                    self.currentSessionUID = session.uid
                }
            } catch {
                await MainActor.run {
                    self.isFetchingSession = false
                    self.errorMessage = "Failed to fetch session: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func signOut() {
        Task {
            do {
                try await SupabaseManager.shared.signOut()
                await MainActor.run {
                    print("Signed out")
                    self.currentSessionUID = nil // Clearing the UID after signing out
                }
            } catch {
                await MainActor.run {
                    print("Signout failed: \(error.localizedDescription)")
                    self.errorMessage = "Signout failed: \(error.localizedDescription)"
                }
            }
        }
    }
}

struct AuthView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    var isDebugMode: Bool
    var body: some View {
        VStack {
            if viewModel.isFetchingSession {
                Text("Fetching")
                    .onAppear {
                        print("Fetching view should now be visible")
                    }
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.gray)
            }
            else if isDebugMode {
                SignInWithDevEmail
                currentSessionText
                SignOutButton
            } else {
                appleSignInButton
                currentSessionText
                SignOutButton
            }
        }
    }

    private var SignInWithDevEmail: some View {
        Button("Sign In with dev email") {
            Task {
                do {
                    let user = try await SupabaseManager.shared.signInWithDevEmail()
                    print("Signed in as \(user.uid)")
                    viewModel.fetchCurrentSession()  // Update session state after sign in
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
                            viewModel.fetchCurrentSession()  // Update session state after sign in
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
    
    private var SignOutButton: some View {
        Button("Sign out") {
            viewModel.signOut()
        }
        .frame(height: 44)
        .frame(maxWidth: .infinity)
        .background(Color.black)
        .foregroundColor(.white)
        .cornerRadius(10)
        .font(.system(size: 17, weight: .semibold))
        .padding()
    }

    
    private var currentSessionText: some View {
        Text(viewModel.currentSessionUID ?? "No current session")
            .font(.system(size: 14, weight: .regular))
            .foregroundColor(.gray)
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = AuthViewModel()

        return Group {
            AuthView(viewModel: viewModel, isDebugMode: true)
                .previewDisplayName("Debug Version")

            AuthView(viewModel: viewModel, isDebugMode: false)
                .previewDisplayName("Release Version")
        }
    }
}
