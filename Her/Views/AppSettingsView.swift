//
//  AppSettingsView.swift
//  Her
//
//  Created by Steven Sarmiento on 3/21/24.
//

import Foundation
import SwiftUI
import UIKit 
import AVFoundation

struct AppSettingsView: View {
    @Binding var isPresented: Bool
    @State private var isMicrophoneEnabled = false
    @State private var showingSettingsAlert = false

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.047, green: 0.071, blue: 0.071), Color(red: 0.047, green: 0.071, blue: 0.071)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            
            VStack {
                
                Spacer()
                    .frame(height: 50)
                
                HStack {
                    Button(action: {
                        isPresented = false
                        let impactMed = UIImpactFeedbackGenerator(style: .soft)
                        impactMed.impactOccurred()
                    }) {
                        HStack {
                            Image(systemName: "xmark")
                                .font(.system(size: 20))
                                .bold()
                                .foregroundColor(.white.opacity(0.3))
                        }
                    }
                    Spacer()
                    
                    Text("Settings")
                        .bold()
                        .font(.system(size: 20, design: .rounded))
                        .foregroundColor(Color.white.opacity(0.8))
                    
                    
                    Spacer()

                    Button(action: {
                        //action
                        let impactMed = UIImpactFeedbackGenerator(style: .soft)
                        impactMed.impactOccurred()
                    }) {
                        // HStack {
                        //     Image(systemName: "party.popper.fill")
                        //         .font(.system(size: 20))
                        //         .bold()
                        //         .foregroundColor(.white.opacity(0.3))
                        // }
                    }
                }
                .padding(.bottom, 20)

                VStack {
                     HStack {
                        Text("Permissions")
                            .bold()
                            .font(.system(size: 14))
                            .foregroundColor(Color.white.opacity(0.5))
                        Spacer()
                    }
                    CustomToggle(title: "Microphone", systemImageName: "mic.fill", isOn: $isMicrophoneEnabled)
                        .onChange(of: isMicrophoneEnabled) { newValue in
                            handleMicrophonePermission(isEnabled: newValue)
                        }
                }

                VStack(alignment: .leading, spacing: 10) {
                        Text("This app is built using:")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.6))
                        
                        Link("VAPI · Voice API", destination: URL(string: "https://vapi.ai")!)
                            .font(.body)
                            .foregroundColor(.white.opacity(0.8))
                        
                        Link("Daily · Calling API", destination: URL(string: "https://www.daily.co")!)
                            .font(.body)
                            .foregroundColor(.white.opacity(0.8))
                        
                        Link("Deepgram · Speech-to-Text API", destination: URL(string: "https://deepgram.com")!)
                            .font(.body)
                            .foregroundColor(.white.opacity(0.8))
                        
                        Link("OpenAI · Voice-to-Text API", destination: URL(string: "https://openai.com")!)
                            .font(.body)
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text("Your conversations are being routed through their servers. They are not private.")
                            .font(.footnote)
                            .foregroundColor(.white.opacity(0.6))
                        
                        Text("We never store personal information about you. However, the conversations are logged.")
                            .font(.footnote)
                            .foregroundColor(.white.opacity(0.6))
                        
                        Text("We will delete the logs on our end.")
                            .font(.footnote)
                            .foregroundColor(.white.opacity(0.6))
                    }
                Spacer()
                Spacer()


            }
            .padding()
            .onAppear {
                 checkMicrophonePermission()
            }
            .alert(isPresented: $showingSettingsAlert) { 
                Alert(
                    title: Text("Microphone Permission"),
                    message: Text("To disable the microphone, please go to Settings and turn off permissions for this app."),
                    primaryButton: .default(Text("Settings")) {
                        // Action to open app settings
                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString),
                            UIApplication.shared.canOpenURL(settingsUrl) else {
                            return
                        }
                        UIApplication.shared.open(settingsUrl)
                    },
                    secondaryButton: .cancel {
                        self.isMicrophoneEnabled = true
                    }
                )
            }          
        }
    }
}



extension AppSettingsView {
    
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

    private func handleMicrophonePermission(isEnabled: Bool) {
        if isEnabled {
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                DispatchQueue.main.async {
                    if granted {
                        self.isMicrophoneEnabled = true
                    } else {
                        self.isMicrophoneEnabled = false
                    }
                }
            }
        } else {
            showingSettingsAlert = true
        }
    }

}

