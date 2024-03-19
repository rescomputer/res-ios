//
//  HerApp.swift
//  Her
//
//  Created by Richard Burton on 03/05/2024.
//

import SwiftUI
import UIKit

struct MainView: View {
    
    @StateObject private var callManager = CallManager()
    @FocusState private var isTextFieldFocused: Bool
    @State private var drawingHeight = true
    @State private var selectedOption: Option?
    
    var body: some View {
        VStack(spacing: 25) {
            
            Spacer()
            // Text Label
            VStack {
                Text("Have a back-and-forth conversation")
                    .font(.system(.title3, design: .default))
                    .multilineTextAlignment(.leading)
                Text("When you talk, it will listen")
                    .font(.system(.callout, design: .default))
                    .multilineTextAlignment(.leading)
            }
            
            .padding(.bottom, 30)
            
            // Text Label
            HStack {
                Text("Who do you want to speak to?")
                Spacer()
            }
            .padding(.bottom, -20)
            
            // OptionsMenu
            OptionsMenu(selectedOption: $selectedOption)
                .frame(height: 250)
                .cornerRadius(10)
                .onChange(of: selectedOption) { newOption in
                        if let newOption = newOption {
                            callManager.enteredText = newOption.description
                        }
                    }
                .padding(0)
            
            HStack {
                Text("Custom Instructions")
                Spacer()
            }
            .padding(.bottom, -20)
            // CustomTextEditor
            HStack {
                CustomTextEditor(text: $callManager.enteredText, isDisabled: callManager.callState != .ended)
                    .frame(height: 100)
                    .background(Color(uiColor: .systemBackground))
                    .cornerRadius(10)
                    .disabled(callManager.callState != .ended) // TODO get this to work with a custom element
            }
            
            
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
            ZStack {
                Color(uiColor: .systemGray6)
                    .ignoresSafeArea(.all)
                Image("flow")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .opacity(0.3)
                    .offset(y: -280)
                    .scaleEffect(1.3)
            }
        }
        
    }
    
    private var animation: Animation {
        .linear(duration: 0.5).repeatForever()
    }
}

struct Option: Identifiable, Equatable {
    let id = UUID()
    let icon: String
    let title: String
    let description: String
}

struct OptionRow: View {
    let option: Option
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: option.icon)
//                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)
                .padding(.top, 4)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(option.title)
                    .font(.system(size: 17, weight: .semibold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(option.description)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
    }
}

struct OptionsMenu: View {
    let options = [
        Option(icon: "atom", title: "Helpful Assistant", description: "A helpful assistant that gets to the point. No bullet points. Answer in less than 5 sentences."),
        Option(icon: "graduationcap.fill", title: "Patient Teacher", description: "A teacher that deeply understands topics and wants to help you learn. Break things down step by step."),
        Option(icon: "figure.run", title: "Personal Trainer", description: "You are a fitness instructor trying to help me get fitter & stronger. You can give me advice on how to be healthy."),
        Option(icon: "person.fill.questionmark", title: "Debate Partner", description: "You always argue the opposite of what I say. You provide the other side of the argument. You push back on everything with an alternate perspective."),
        Option(icon: "person.and.background.dotted", title: "Friendly Advisor", description: "You are an empathetic listener. You hear what I am sharing and try to offer useful advice. You help me with important decisions in life.")
    ]
    
    @Binding var selectedOption: Option?
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(options) { option in
                    OptionRow(option: option)
                        .onTapGesture {
                            selectedOption = option
                        }
                        .id(option.id)
                        .background(Color.white)
                }
            }
        }
    }
}

#Preview {
    MainView()
}
