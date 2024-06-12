import SwiftUI
import AuthenticationServices

struct AuthView: View {
    @Binding var isChangelogViewShowing: Bool
    @Binding var isAppSettingsViewShowing: Bool
    @Binding var isModalStepTwoEnabled: Bool
    
    var isDebugMode: Bool
    @State private var showAuthContent = false
    @State private var isLoggedIn = false

    var body: some View {
        ZStack {
            MainViewTeenageEng(
                isChangelogViewShowing: $isChangelogViewShowing,
                isAppSettingsViewShowing: $isAppSettingsViewShowing,
                isModalStepTwoEnabled: $isModalStepTwoEnabled,
                modalStepTwoEnabled: $isModalStepTwoEnabled
            )
            .zIndex(0)

            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
                .zIndex(1)

            ZStack {
                ResUserGuide
                    .zIndex(1)

                VStack {
                    FeaturesText

                    if isDebugMode {
                        SignInWithDevEmail
                            .padding(.top, 30)

                    } else {
                        appleSignInButton
                            .padding(.top, 30)

                    }
                }
                .padding(.horizontal, 30)
                .onAppear {
                    print("isDebugMode:", isDebugMode)
                    print("Build Configuration:", Config.buildConfiguration)
                }
                .zIndex(2)
            }
            .slideDown()
            .zIndex(2)
        }
    }

    private var FeaturesText: some View {
         VStack(alignment: .leading, spacing: 10) {
            listItem(icon: "dial.high.fill", title: "Total Control", text: "Control the speed, accent, and gender of your AI. You control who you are talking to.")
            listItem(icon: "face.smiling.inverse", title: "Real Conversation", text: "Choose between presets or set custom prompting for every conversation.")
            listItem(icon: "eye.slash.fill", title: "Privacy first", text: "HIPPA enabled privacy when you want it, your conversations are special, keep them private if you need.")
        }
        .padding(.top, 50)
        .padding(.vertical)
    }

    private var ResUserGuide: some View {
        Image("res-userguide")
            .resizable()
            .scaledToFit()
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
        .frame(height: 54)
        .frame(maxWidth: .infinity)
        .background(Color.clear)
        .foregroundColor(.black)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.black, lineWidth: 2)
        )
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
        .frame(height: 54)
        .frame(maxWidth: .infinity)
        .background(Color.clear)
        .foregroundColor(.black)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.black, lineWidth: 2)
        )
        .font(.system(size: 17, weight: .semibold))
        .padding()
    }
}

private func listItem(icon: String, title: String, text: String) -> some View {
    VStack(alignment: .leading) {
        Image(systemName: icon)
            .font(.system(size: 21))
            .foregroundColor(Color.black.opacity(0.9))
            .padding(.vertical, 10)
        // RoundedRectangle(cornerRadius: 16)
        //     .frame(width: 50, height: 50)
        //     .foregroundColor(Color.clear)
        //     .overlay(
        //         Image(systemName: icon)
        //         .font(.system(size: 21))
        //        .foregroundColor(Color.black.opacity(0.9))
                
        //     )

        VStack(alignment: .leading){
            Text(title)
                .font(.callout)
                .bold()
                .foregroundColor(.black)
                
            
            Text(text)
                .font(.system(size: 12))
                .foregroundColor(.black.opacity(0.5))
        }
    }
    .padding(.horizontal, 20)
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AuthView(
                isChangelogViewShowing: .constant(false),
                isAppSettingsViewShowing: .constant(false),
                isModalStepTwoEnabled: .constant(false),
                isDebugMode: true
            )
            .previewDisplayName("Debug Version")

            AuthView(
                isChangelogViewShowing: .constant(false),
                isAppSettingsViewShowing: .constant(false),
                isModalStepTwoEnabled: .constant(false),
                isDebugMode: false
            )
            .previewDisplayName("Release Version")
        }
    }
}
