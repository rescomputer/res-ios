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
    
    var showSaveButton: Bool
    var saveSettingsAction: () -> Void
    var backgroundContext: BackgroundContext

    enum BackgroundContext {
        case white, black
    }

    var body: some View {
        VStack(alignment: .leading) {
            // Pickers
            Text("Voice Type")
                .bold()
                .font(.system(size: 14))
                .foregroundColor(backgroundContext == .white ? Color.black.opacity(0.5) : Color.white.opacity(0.5))
                .padding(.top, 5)


            VStack {
                //audio picker
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
                        .onChange(of: callManager.voice) { oldValue, newVoice in
                            UserDefaults.standard.set(newVoice, forKey: "voice")
                        }
                    } label: {
                        HStack {
                            Text(callManager.voiceDisplayName)
                                .font(.system(size: 14))
                                .foregroundColor(backgroundContext == .white ? Color.black.opacity(1) : Color.white.opacity(1))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 8)
                        .background(backgroundContext == .white ? Color.black.opacity(0.05) : Color.white.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: 50))
                        .overlay(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke((backgroundContext == .white ? Color.black.opacity(0.05) : Color.white.opacity(0.05)), lineWidth: 1)
                        )
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    //.layoutPriority(3)

                    // Button(action: {
                    //     callManager.playVoicePreview()
                    // }) {
                    //     Image(systemName: "waveform")
                    //         .font(.system(size: 22))
                    //         .foregroundColor(.black.opacity(0.4))
                    //         .padding(4)
                    // }
                    // .background(Color.black.opacity(0.05))
                    // .clipShape(Circle())
                    // .overlay(
                    //     RoundedRectangle(cornerRadius: 50)
                    //         .stroke(Color.black.opacity(0.05), lineWidth: 1)
                    // )
                    // .layoutPriority(1)
                }
                // Audio Visualizer
                // AudioVisualizerView()
                //     .frame(height: 80)
                //     .padding(.vertical, 10)

                VStack(alignment: .leading) {
                    Text("Voice Speed")
                        .bold()
                        .font(.system(size: 14))
                        .foregroundColor(backgroundContext == .white ? Color.black.opacity(0.5) : Color.white.opacity(0.5))
                        .padding(.top, 5)

                    HStack {
                        Image(systemName: "tortoise.fill")
                            .foregroundColor(backgroundContext == .white ? Color.black.opacity(0.3) : Color.white.opacity(0.3))
                            
                            Slider(value: $callManager.speed, in: 0.3...1.5, step: 0.1) { changing in
                                if !changing {
                                    let generator = UIImpactFeedbackGenerator(style: .medium)
                                    generator.impactOccurred()
                                    UserDefaults.standard.set(callManager.speed, forKey: "speed")
                                }
                            }
                            .accentColor(Color(red: 0.106, green: 0.149, blue: 0.149))                            

                        Image(systemName: "hare.fill")
                            .foregroundColor(backgroundContext == .white ? Color.black.opacity(0.3) : Color.white.opacity(0.3))
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                }
                .frame(maxWidth: .infinity)
            }   
            if showSaveButton {
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

        }
        .padding(.horizontal, 20)
    }
}
