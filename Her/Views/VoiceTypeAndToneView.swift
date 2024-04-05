//
//  VoiceTypeAndToneView.swift
//  Her
//
//  Created by Steven Sarmiento on 4/4/24.
//

import SwiftUI

struct VoiceTypeAndToneView: View {
    @Binding var activeModal: MainView.ActiveModal?
    @Binding var selectedOption: Option?
    @ObservedObject var callManager: CallManager
    @ObservedObject var keyboardResponder: KeyboardResponder
    @State private var currentStep: Int = 1
    
    var saveSettingsAction: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            // Pickers
            Text("Voice Settings")
                .bold()
                .font(.system(size: 14))
                .foregroundColor(Color.black.opacity(0.5))
                .padding(.top, 5)


            HStack {
                Menu {
                    Picker("Voice", selection: $callManager.voice) {
                        Text("🇺🇸 Alloy · Gentle Man").tag("alloy")
                        Text("🇺🇸 Echo · Deep Man").tag("echo")
                        Text("🇬🇧 Fable · Normal Man").tag("fable")
                        Text("🇺🇸 Onyx · Deeper Man").tag("onyx")
                        Text("🇺🇸 Nova · Gentle Woman").tag("nova")
                        Text("🇺🇸 Shimmer · Deep Woman").tag("shimmer")
                    }
                    .onChange(of: callManager.voice) {oldValue , newVoice in
                        UserDefaults.standard.set(newVoice, forKey: "voice")
                    }
                } label: {
                    HStack {
                        Text(callManager.voiceDisplayName)
                            .font(.system(size: 14))
                            .foregroundColor(.black.opacity(1))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 8)
                    .background(Color.black.opacity(0.05))
                    .clipShape(RoundedRectangle(cornerRadius: 50))
                    .overlay(
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(Color.black.opacity(0.05), lineWidth: 1)
                    )
                }

                Menu {
                    Picker("Speed", selection: $callManager.speed) {
                        Text("🐢 Slow").tag(0.3)
                        Text("💬 Normal").tag(1.0)
                        Text("🐇 Fast").tag(1.3)
                        Text("⚡️ Superfast").tag(1.5)
                    }
                    .onChange(of: callManager.speed) {oldValue , newSpeed in
                        UserDefaults.standard.set(newSpeed, forKey: "speed")
                    }
                } label: {
                    HStack {
                        Text(callManager.speedDisplayName)
                            .font(.system(size: 14))
                            .foregroundColor(.black.opacity(1))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 8)
                    .background(Color.black.opacity(0.05))
                    .clipShape(RoundedRectangle(cornerRadius: 50))
                    .overlay(
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(Color.black.opacity(0.05), lineWidth: 1)
                    )
                }
            }
        // Save Button
        // Button {
        //         self.activeModal = nil
        //     } label: {
        //         Text("Save Settings")
        //             .font(.system(.title2, design: .rounded))
        //             .fontWeight(.bold)
        //             .foregroundColor(.white)
        //             .padding()
        //             .frame(maxWidth: .infinity)
        //             .background(Color(red: 0.106, green: 0.149, blue: 0.149))
        //             .cornerRadius(50)
        //     }
        //     .pressAnimation()
        //     .buttonStyle(.plain)
        //     .padding(.top, 5)
        //     .opacity(1)
        //     .animation(nil)
            
            // Save Button
            ZStack {
                    RoundedRectangle(cornerRadius: 50)
                        .foregroundColor(Color(red: 0.106, green: 0.149, blue: 0.149))
                        .frame(height: 60)
                        .animation(nil)
                    Text("Save Settings")
                        .font(.system(.title2, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .onTapGesture {
                    self.activeModal = nil
                }
                .padding(.top, 5)
                .pressAnimation()
                .opacity(1)
        }
        .padding(.horizontal, 20)
    }
}
