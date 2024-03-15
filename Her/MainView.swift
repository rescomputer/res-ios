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
            CustomTextEditor(text: $callManager.enteredText)
                .frame(height: 200)
                .background(Color(uiColor: .systemBackground))
                .cornerRadius(10)
            
            Spacer()
            
            // Pickers
            List {
                
                // Voice Picker
                Picker("Voice", selection: $callManager.voice) {
                    Text("🇺🇸 Alloy · Gentle American Man").tag("alloy")
                    Text("🇺🇸 Echo · Deep American Man").tag("echo")
                    Text("🇬🇧 Fable · Normal British Man").tag("fable")
                    Text("🇺🇸 Onyx · Deeper American Man").tag("onyx")
                    Text("🇺🇸 Nova · Gentle American Woman").tag("nova")
                    Text("🇺🇸 Shimmer · Deep American Woman").tag("shimmer")
                }
                .onReceive(callManager.$voice) { newVoice in
                    UserDefaults.standard.set(newVoice, forKey: "voice")
                }
                
                // Speed Picker
                Picker(selection: $callManager.speed) {
                    Text("🐢 Slow").tag(0.3)
                    Text("💬 Normal").tag(8.0)
                    Text("🐇 Fast").tag(1.3)
                    Text("⚡️ Superfast").tag(1.5)
                } label: {
                    Text("Speed")
                }
            }
            .frame(height: 88)
            .listStyle(.plain)
            .cornerRadius(15)
            
            .onReceive(callManager.$speed) { newSpeed in
                UserDefaults.standard.set(newSpeed, forKey: "speed")
            }
            
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
            LinearGradient(gradient: bluePurpleGradient, startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
        }
    }
    
    private var bluePurpleGradient: Gradient {
        Gradient(colors: [Color.blue.opacity(0.7), Color.purple.opacity(0.7)])
    }
    
    private var animation: Animation {
        .linear(duration: 0.5).repeatForever()
    }
}

#Preview {
    MainView()
}
