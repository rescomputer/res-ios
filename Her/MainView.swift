//
//  HerApp.swift
//  Her
//
//  Created by Richard Burton on 03/05/2024.
//

import SwiftUI

struct MainView: View {
    
    @StateObject private var callManager = CallManager()
    @FocusState private var isTextFieldFocused: Bool
    @State private var drawingHeight = true
    
    var body: some View {
        VStack(spacing: 25) {
            
            // Text Label
            HStack {
                Spacer()
                Text("Have a back-and-forth conversation")
                    .font(.system(.title3, design: .default))
                    .multilineTextAlignment(.center)
                
                Spacer()
            }
            .padding(.top)
            
            // Text Label
            HStack {
                Spacer()
                Text("When you talk, it will listen")
                    .font(.system(.callout, design: .default))
                    .multilineTextAlignment(.center)
                Spacer()
            }
            .padding(.bottom, 30)
            
            // Text Label
            HStack {
                Text("Custom Instructions")
                Spacer()
            }
            .padding(.bottom, -20)
            
            // CustomTextEditor
            HStack {
                CustomTextEditor(text: $callManager.enteredText, isDisabled: callManager.callState != .ended)
                    .frame(height: 200)
                    .background(Color(uiColor: .systemBackground))
                    .cornerRadius(10)
                    .disabled(callManager.callState != .ended) // TODO get this to work with a custom element
            }
            
            Spacer()
            
            // Pickers
            List {
                
                // Voice Picker
                Picker("Voice", selection: $callManager.voice) {
                    Text("🇺🇸 Alloy · Gentle Man").tag("alloy")
                    Text("🇺🇸 Echo · Deep Man").tag("echo")
                    Text("🇬🇧 Fable · Normal Man").tag("fable")
                    Text("🇺🇸 Onyx · Deeper Man").tag("onyx")
                    Text("🇺🇸 Nova · Gentle Woman").tag("nova")
                    Text("🇺🇸 Shimmer · Deep Woman").tag("shimmer")
                    .onReceive(callManager.$voice) { newVoice in
                        UserDefaults.standard.set(newVoice, forKey: "voice")
                    }
                }

                .disabled(callManager.callState != .ended)
                
                // Speed Picker
                Picker("Speed", selection: $callManager.speed) {
                    Text("🐢 Slow").tag(0.3)
                    Text("💬 Normal").tag(1.0)
                    Text("🐇 Fast").tag(1.3)
                    Text("⚡️ Superfast").tag(1.5)
                    .onReceive(callManager.$speed) {  newSpeed in
                        UserDefaults.standard.set(newSpeed, forKey: "speed")
                    }
                }
                .disabled(callManager.callState != .ended)
            }
            .frame(height: 88)
            .listStyle(.plain)
            .cornerRadius(15)
            
            // Start Button
            Button {
                Task {  await callManager.handleCallAction() }
            } label: {
                Text(callManager.buttonText)
                    .font(.system(.title2, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(callManager.buttonColor)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.vertical)
            
            .disabled(callManager.callState == .loading)
            
        }
        .padding(.horizontal)
        .onAppear { callManager.setupVapi() }
        .background {
            Color(uiColor: .systemGray6)
                .ignoresSafeArea(.all)
        }
        
    }
    
    private var animation: Animation {
        .linear(duration: 0.5).repeatForever()
    }
}


#Preview {
    MainView()
}
