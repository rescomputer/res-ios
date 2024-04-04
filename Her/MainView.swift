//
//  HerApp.swift
//  Her
//
//  Created by Richard Burton on 03/05/2024.
//

import SwiftUI
import UIKit
import ActivityKit

struct MainView: View {
    
    @StateObject private var callManager = CallManager()
    @StateObject private var keyboardResponder = KeyboardResponder()

    @FocusState private var isTextFieldFocused: Bool
    @State private var drawingHeight = true
    @State private var selectedOption: Option?
    @State private var activeModal: ActiveModal?
    @Binding var isAppSettingsViewShowing: Bool

    var body: some View {
        VStack(spacing: 25) {
            // Top Nav
            HStack {
                Spacer()
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.15)) {
                        isAppSettingsViewShowing = true
                    }
                    let impactMed = UIImpactFeedbackGenerator(style: .soft)
                    impactMed.impactOccurred()
                }) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 20))
                        .bold()
                        .foregroundColor(.white.opacity(0.3))
                }
            }
            
            Spacer()
            VStack {
                Text("Let’s have some back and forth conversation.")
                    .bold()
                    .font(.system(size: 30, design: .rounded))
                    .foregroundColor(Color.white.opacity(1))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 10)
                Text("When you talk, I listen 🙂")
                    .font(.system(size: 22, design: .rounded))
                    .foregroundColor(Color.white.opacity(0.5))
            }
            Spacer()

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
                    .cornerRadius(50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(Color.black.opacity(1), lineWidth: 1)
                    )
            }
            .pressAnimation()
            .buttonStyle(PlainButtonStyle())

            
            .disabled(callManager.callState == .loading)
            
            HStack {
                Button(action: {
                        self.activeModal = .voiceSettingsModal
                        let impactMed = UIImpactFeedbackGenerator(style: .soft)
                        impactMed.impactOccurred()
                    }) {
                        HStack {
                            Image(systemName: "waveform")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(Color.white.opacity(0.5))
                                // .padding()
                            Text("Personality & Voice")
                                .font(.system(size: 18))
                                .foregroundColor(Color.white.opacity(0.6))
                    }
                }
            }
            .padding(.bottom, 10)
            
        }
        .padding()
        .padding(.horizontal, 10)
        .onAppear { callManager.setupVapi() }
        .background {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color(red: 0.047, green: 0.071, blue: 0.071), Color(red: 0.047, green: 0.071, blue: 0.071)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
//                RadialGradient(gradient: Gradient(colors: [Color(red: 0.247, green: 0.106, blue: 0.153), Color(red: 0.133, green: 0.067, blue: 0.118)]), center: .trailing, startRadius: 5, endRadius: 400)
//                
//                RadialGradient(gradient: Gradient(colors: [Color.blue.opacity(0.5), Color.purple.opacity(0.5)]), center: .leading, startRadius: 2, endRadius: 500)
//                    .opacity(0.9)
//                
//                RadialGradient(gradient: Gradient(colors: [Color.green.opacity(0.4), Color.yellow.opacity(0.5)]), center: .bottom, startRadius: 1, endRadius: 600)
//                    .opacity(0.8)
                
                Image("flow")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .opacity(0.3)
                    .scaleEffect(1.3)
            }
            .ignoresSafeArea(.all)

        }
        .overlay {
            if let activeModal = activeModal {
                switch activeModal {
                case .voiceSettingsModal:
                    showVoiceSettingsModal(keyboardResponder: keyboardResponder)
                }
            }
            if isAppSettingsViewShowing {
                AppSettingsView(isPresented: $isAppSettingsViewShowing)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
                    .fadeInEffect()
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
        VStack(spacing: 2) {
            ZStack{
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.05))
                    .frame(width: 53, height: 53)
                Image(systemName: option.icon)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                    .padding(.top, 4)
                    .foregroundColor(Color.black.opacity(0.8))                
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(option.title)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Color.black.opacity(0.3))

            }
        }
    }
}

struct OptionsMenu: View {
    let options = [
        Option(icon: "atom", title: "Assistant", description: "A helpful assistant that gets to the point. No bullet points. Answer in less than 5 sentences."),
        Option(icon: "graduationcap.fill", title: "Educator", description: "A teacher that deeply understands topics and wants to help you learn. Break things down step by step."),
        Option(icon: "figure.run", title: "Trainer", description: "You are a fitness instructor trying to help me get fitter & stronger. You can give me advice on how to be healthy."),
        Option(icon: "person.fill.questionmark", title: "Debater", description: "You always argue the opposite of what I say. You provide the other side of the argument. You push back on everything with an alternate perspective."),
        Option(icon: "person.and.background.dotted", title: "Guru", description: "You are an empathetic listener. You hear what I am sharing and try to offer useful advice. You help me with important decisions in life.")
    ]
    
    @Binding var selectedOption: Option?
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 11) {
                ForEach(options) { option in
                    OptionRow(option: option)
                        .onTapGesture {
                            selectedOption = option
                        }
                        .id(option.id)
                }
            }
        }
        .frame(maxHeight: 90)
    }
}

extension MainView {

    enum ActiveModal {
        case voiceSettingsModal
    }
    
    enum ModalHeightMultiplier {
        case voiceSettingsModal

        var value: CGFloat {
            switch self {
            case .voiceSettingsModal: return 0.16
            }
        }
    }

    private func showVoiceSettingsModal(keyboardResponder: KeyboardResponder) -> some View {

        HalfModalView(isShown: Binding<Bool>(
            get: { self.activeModal == .voiceSettingsModal },
            set: { newValue in
                if !newValue {
                    self.activeModal = nil
                }
            }
        ), onDismiss: {
            withAnimation(.easeInOut(duration: 0.15)) {
                self.activeModal = nil
            }
        }, modalHeightMultiplier: MainView.ModalHeightMultiplier.voiceSettingsModal.value
        ) {
            VoiceSettingsView(activeModal: $activeModal, selectedOption: $selectedOption, callManager: callManager, keyboardResponder: keyboardResponder)
        }
    }
}
