//
//  OnboardingView.swift
//  Res
//
//  Created by Steven Sarmiento on 9/15/24.
//

import SwiftUI
import AVFoundation

struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    @State private var currentStep = 0
    @State private var isMicrophoneEnabled = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 1, green: 0.482, blue: 0.188),
                    Color(red: 0.945, green: 0.298, blue: 0.122)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)

            VStack(alignment: .leading) {
                Image("logo-res")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .zIndex(1)

                if currentStep == 0 {
                    WelcomeStep(nextStep: { currentStep += 1 })
                } else {
                    PermissionsStep(completeOnboarding: {
                        hasCompletedOnboarding = true
                    }, isMicrophoneEnabled: $isMicrophoneEnabled)
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

struct WelcomeStep: View {
    let nextStep: () -> Void
    
    var body: some View {
         VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading, spacing: 20) {
                Text("Meet RES, an app where you can talk with AI using Real Electronic Speech.")
                    .font(.system(size: 38, weight: .regular, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.top, 30)
                Text("Get started for free. Upgrade to RES Pro at anytime to enjoy unlimited calls.")
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(0)
                    .padding(.bottom, 20)
                }
                .slideUp()
                Spacer()
                SecondaryButton(title: "Continue") {
                    nextStep()
                }
        }
    }
}

struct PermissionsStep: View {
     let completeOnboarding: () -> Void
    @Binding var isMicrophoneEnabled: Bool
    @State private var showingSettingsAlert = false
    
    var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading, spacing: 20) {
                Text("Before we begin...")
                        .font(.system(size: 38, weight: .regular, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.top, 30)
                Text("RES would like permission to request access to your microphone. Microphone access will allow you to call and talk to the contacts.")
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(0)
                Text("We do not record, store, or share any conversations or personal audio.")
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(0)

                CustomPermissionToggle(
                    title: "Microphone",
                    description: "Res uses your microphone to enable voice conversations within your calls.",
                    systemImageName: isMicrophoneEnabled ? "mic.fill" : "mic.slash.fill",
                    isEnabled: $isMicrophoneEnabled
                ) {
                    requestMicrophonePermission()
                }
                }
                .slideLeft()
                Spacer()
                
                SecondaryButton(title: "Continue") {
                    completeOnboarding()
                }
                .padding(.top, 20)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .onChange(of: isMicrophoneEnabled) { oldValue, newValue in
                handleMicrophonePermission(isEnabled: newValue)
            }
            .onAppear {
                checkMicrophonePermission()
            }
            .alert(isPresented: $showingSettingsAlert) {
                Alert(
                    title: Text("Microphone Permission"),
                    message: Text("To enable the microphone, please go to Settings and turn on permissions for this app."),
                    primaryButton: .default(Text("Settings")) {
                        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(settingsUrl)
                        }
                    },
                    secondaryButton: .cancel {
                        self.isMicrophoneEnabled = false
                    }
                )
            }
    }

    private func checkMicrophonePermission() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            isMicrophoneEnabled = true
        case .denied, .undetermined:
            isMicrophoneEnabled = false
        @unknown default:
            isMicrophoneEnabled = false
        }
    }

    private func requestMicrophonePermission() {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            DispatchQueue.main.async {
                self.isMicrophoneEnabled = granted
            }
        }
    }

    private func handleMicrophonePermission(isEnabled: Bool) {
        if isEnabled {
            requestMicrophonePermission()
        } else {
            showingSettingsAlert = true
        }
    }
}

#Preview {
    OnboardingView(hasCompletedOnboarding: .constant(false))
}
