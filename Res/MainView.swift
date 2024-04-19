//
//  ResApp.swift
//  Res
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
    @Binding var isModalStepTwoEnabled: Bool

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
                ZStack {
                            if callManager.callState == .loading {
                                HStack(spacing: 10) {
                                    Loader()
                                        .frame(width: 17, height: 17)
                                        .scaleUpAnimation()
                                    Text(callManager.buttonText)
                                        .fadeInEffect()

                                }
                            } else {
                                    Text(callManager.buttonText)
                                        .fadeInEffect()
                            }
                    }
                    .font(.system(.title2, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(callManager.buttonColor)
                    .cornerRadius(50)
                    .overlay(
                    // Inner dark stroke
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(Color.black.opacity(1), lineWidth: 1)
                    )
                    .overlay(
                    // Inner light stroke
                        RoundedRectangle(cornerRadius: 50, style: .continuous)
                            .strokeBorder(
                                LinearGradient(
                                colors: [
                                    Color.white.opacity(0.5),
                                    Color.white.opacity(0),
                                    Color.black.opacity(0.5)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                                ),
                                lineWidth: 2
                            )
                            .blendMode(.overlay)
                            //.opacity(0.3)
                    )
                    .onTapGesture {
                        Task {  await callManager.handleCallAction() }
                        let impactMed = UIImpactFeedbackGenerator(style: .soft)
                        impactMed.impactOccurred()
                    }
                    .padding(.top, 5)
                    .pressAnimation()
                    .opacity(1)                
            
            .disabled(callManager.callState == .loading)
            
            HStack {
                Button(action: {
                        self.activeModal = .voiceSettingsModal
                        let impactMed = UIImpactFeedbackGenerator(style: .soft)
                        impactMed.impactOccurred()
                    }) {
                        HStack(spacing: 10) {
                            Image(systemName: "waveform")
                                .font(.system(size: 22))
                                .foregroundColor(Color.white.opacity(0.5))
                        if isModalStepTwoEnabled {
                            Text("Personality")
                                .font(.system(size: 18))
                                .foregroundColor(Color.white.opacity(0.6))
                        } else {
                            Text("Personality & Voice")
                                .font(.system(size: 18))
                                .foregroundColor(Color.white.opacity(0.6))
                        }
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
                AppSettingsView(
                    isPresented: $isAppSettingsViewShowing,
                    activeModal: $activeModal, 
                    selectedOption: $selectedOption, 
                    isModalStepTwoEnabled: $isModalStepTwoEnabled,
                    callManager: callManager, 
                    keyboardResponder: keyboardResponder
                )
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

extension MainView {

    enum ActiveModal {
        case voiceSettingsModal
    }
    
    enum ModalHeightMultiplier {
        case voiceSettingsModal

        var value: CGFloat {
            switch self {
            case .voiceSettingsModal: return 0.06
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
            VoiceSettingsView(
                activeModal: $activeModal, 
                selectedOption: $selectedOption,
                isModalStepTwoEnabled: $isModalStepTwoEnabled,
                callManager: callManager, 
                keyboardResponder: keyboardResponder)
                .background(
                    RoundedRectangle(cornerRadius: 40)
                        .fill(Color.white)
                )
        }
    }
}
