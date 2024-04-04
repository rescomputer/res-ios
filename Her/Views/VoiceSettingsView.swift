//
//  VoiceSettingsView.swift
//  Her
//
//  Created by Steven Sarmiento on 4/4/24.
//

import SwiftUI

struct VoiceSettingsView: View {
    @Binding var activeModal: MainView.ActiveModal?
    @Binding var selectedOption: Option?
    @ObservedObject var callManager: CallManager
    @ObservedObject var keyboardResponder: KeyboardResponder
    @State private var currentStep: Int = 1

    var body: some View {
        VStack {
            ZStack {
                HStack {
                    ZStack {
                        HStack {
                            Image(systemName: "waveform")
                                .resizable()
                                .foregroundColor(.black.opacity(0.05))
                                .frame(width: 85, height: 85)
                            Spacer()
                        }
                        .offset(x: 10, y: -20)

                    
                        VStack(alignment: .leading) {
                            Text("Who do you want to talk to?")
                                .font(.system(size: 20, design: .rounded))
                                .bold()
                                .foregroundColor(Color.black.opacity(1))
                                .padding(.bottom, 2)
                            Text("Choose a preset prompt or create your own custom Ai to converse with.")
                                .font(.system(size: 14))
                                .foregroundColor(Color.black.opacity(0.5))

                        }
                        .padding(.horizontal, 20)
                        .offset(x: UIScreen.isLargeDevice ? 0 : -12)
                    }
                }
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color.black.opacity(0.1)),
                    alignment: .bottom
                )
            }
            .overlay(
                RoundedRectangle(cornerRadius: 0)
                    .fill(Color.black.opacity(0.05))
                    .frame(maxWidth: .infinity)
                    .frame(height: 140),
                     alignment: .bottom
                )
            .overlay(
                XMarkButton {
                    withAnimation(.spring(response: 0.2, dampingFraction: 0.5, blendDuration: 0)) {
                        if currentStep == 2 {
                            currentStep = 1
                        } else {
                            // withAnimation(.spring(response: 0.2, dampingFraction: 0.5, blendDuration: 0)) {
                            // }  
                            self.activeModal = nil
                      
                        }
                    }
                }
                .offset(x: -20, y: 0),
                alignment: .topTrailing
            )


            if currentStep == 1 {
                VStack(alignment: .leading) {
                    Text("Custom Prompt")
                            .bold()
                            .font(.system(size: 14))
                            .foregroundColor(Color.black.opacity(0.5))
                            .padding(.top, 5)

                        // CustomTextEditor
                        HStack {
                            CustomTextEditor(text: $callManager.enteredText, isDisabled: callManager.callState != .ended)
                                .frame(height: 100)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 3)
                                .background(Color.black.opacity(0.05))
                                .cornerRadius(15)
                                .disabled(callManager.callState != .ended) // TODO get this to work with a custom element
                        }

                        if keyboardResponder.currentHeight == 0 {
                            // Text Label
                            Text("Prompt Presets")
                                    .bold()
                                    .font(.system(size: 14))
                                    .foregroundColor(Color.black.opacity(0.5))
                                    .padding(.top, 5)
                            
                            // OptionsMenu
                            HStack{
                                OptionsMenu(selectedOption: $selectedOption)
                                    .frame(height: 70)
                                    .onChange(of: selectedOption) {oldValue , newOption in
                                            if let newOption = newOption {
                                                callManager.enteredText = newOption.description
                                            }
                                        }
                            }
                        }
                        // Continue Button
                        Button {
                            withAnimation(.spring(response: 0.2, dampingFraction: 0.5, blendDuration: 0)) {
                                currentStep = 2
                            }                    
                            } label: {
                                Text("Continue")
                                    .font(.system(.title2, design: .rounded))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color(red: 0.106, green: 0.149, blue: 0.149))
                                    .cornerRadius(50)
                            }
                            .pressAnimation()
                            .buttonStyle(PlainButtonStyle())
                            .padding(.top, 5)
                }
                .padding(.horizontal,20)
 
            } else if currentStep == 2 {
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
                Button {
                        self.activeModal = nil                                        
                    } label: {
                        Text("Save Settings")
                            .font(.system(.title2, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(red: 0.106, green: 0.149, blue: 0.149))
                            .cornerRadius(50)
                    }
                    .pressAnimation()
                    .buttonStyle(PlainButtonStyle())
                    .padding(.top, 5)                    
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.vertical)  
        }
}
