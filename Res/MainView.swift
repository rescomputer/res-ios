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
    @FocusState private var isTextFieldFocused: Bool
    
    @StateObject private var callManager = CallManager()
    @StateObject private var audioManager = AudioManager()
    @StateObject private var keyboardResponder = KeyboardResponder()
    
    @Binding var isAppSettingsViewShowing: Bool
    @Binding var isModalStepTwoEnabled: Bool
    
    @State private var drawingHeight = true
    @State private var selectedOption: Option?
    @State private var activeModal: ActiveModal?
    
    var body: some View {
        ZStack {
            backgroundGradient

            VStack {
                greenScreen
                resMarker
                Spacer()
                mainButton
                setupButtons
            }
            .padding()
            .padding(.bottom)
            .padding(.horizontal, 10)
            
            .overlay(cornerTick, alignment: .bottomLeading)
            .overlay(borderShadow)
            
            .background(backgroundColor)
            
            .overlay(backgroundNoise)
            .overlay(whiteBorder)
            
            .clipShape(RoundedRectangle(cornerRadius: 55))
            .overlay(topTick, alignment: .top)
        }
        .ignoresSafeArea(edges: .bottom)
        
        .onAppear { callManager.setupVapi() }
        .overlay { voiceSetupSheet }
        .overlay { if isAppSettingsViewShowing { appSettingsSheet } }
    }
    
    // Components
    private var backgroundGradient: some View {
        LinearGradient(
            gradient: greenGradient,
//            Gradient(colors: [Color(red: 0.047, green: 0.071, blue: 0.071), Color(red: 0.047, green: 0.071, blue: 0.071)]
            startPoint: .top,
            endPoint: .bottom
        )
        .edgesIgnoringSafeArea(.all)
    }
    
    private var greenScreen: some View {
        ZStack {
            VStack {
                Image(.roboto)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .padding(.bottom, 100)
                
//                Text(callManager.currentTranscript)
//                    .frame(maxWidth: .infinity, alignment: .center)
//                    .padding()
//                    .background(Color.white.opacity(0.5))
//                    .cornerRadius(10)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 500)
        .background(LinearGradient( gradient: greenGradient, startPoint: .top, endPoint: .bottom))
        .clipShape(RoundedRectangle(cornerRadius: 34))
        
        .overlay(
            Image(.bgNoise)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .opacity(0.5)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 34)
                .strokeBorder(LinearGradient(gradient: Gradient(colors: [.black, .black]), startPoint: .top, endPoint: .trailing), lineWidth: 14)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 34)
                .strokeBorder(LinearGradient(gradient: Gradient(colors: [Color(red: 0.878, green: 0.863, blue: 0.824), Color(red: 0.878, green: 0.863, blue: 0.824)]), startPoint: .bottom, endPoint: .leading), lineWidth: 12)
        )
        .shadow(color: Color.black.opacity(0.15), radius: 3, x: 0, y: 0)
    }
    
    private var greenGradient: Gradient {
        Gradient(colors: [Color(red: 0.067, green: 0.094, blue: 0.063),
                          Color(red: 0.071, green: 0.192, blue: 0.078)])
    }
    
    private var resMarker: some View {
        Image(.resMarker)
            .resizable()
            .scaledToFill()
            .frame(height: 5)
            .padding(.top, 10)
    }
    
    private var mainButton: some View {
        ZStack {
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
            .background(callManager.buttonGradient)
            .overlay(
                Image(.bgNoise)
                    .resizable()
                    .frame(height: 60)
                    .opacity(1)
            )
            .cornerRadius(50)
            // .overlay(
            // // Inner dark stroke
            //     RoundedRectangle(cornerRadius: 50)
            //         .stroke(Color(red: 0.275, green: 0.122, blue: 0.063), lineWidth: 1)
            // )
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
                        lineWidth: 3
                    )
                    .blendMode(.overlay)
                //.opacity(0.3)
            )
            .onTapGesture {
                Task {  await callManager.handleCallAction() }
                let impactMed = UIImpactFeedbackGenerator(style: .soft)
                impactMed.impactOccurred()
            }
            .pressAnimation()
            .opacity(1)
            .padding(2)
            .padding(.vertical, 0)
            
        }
        
        .background(RoundedRectangle(cornerRadius: 50)
            .fill(Color.black))
        .shadow(color: Color.black.opacity(0.5), radius: 3, x: 0, y: 0)
        
        .disabled(callManager.callState == .loading)
        
        .padding(.top, 20)
    }
    
    private var setupButtons: some View {
        HStack(spacing: 20) {
            Spacer()
            
            //personality & voice
            ZStack {
                Button(action: {
                    self.activeModal = .voiceSettingsModal
                    let impactMed = UIImpactFeedbackGenerator(style: .soft)
                    impactMed.impactOccurred()
                }) {
                    ZStack {
                        Image(systemName: "brain.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.black.opacity(0.5))
                    }
                }
                .padding()
                .frame(width: 60, height: 60)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color(red: 0.729, green: 0.725, blue: 0.71), Color(red: 1, green: 0.98, blue: 0.933)]), startPoint: .top, endPoint: .bottom)
                )
                .cornerRadius(50)
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
                            lineWidth: 3
                        )
                        .blendMode(.overlay)
                    //.opacity(0.3)
                )
                .pressAnimation()
                .padding(2)
            }
            .background(RoundedRectangle(cornerRadius: 50)
                .fill(Color.black))
            .shadow(color: Color.black.opacity(0.5), radius: 3, x: 0, y: 0)
            
            // settings
            ZStack {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.15)) {
                        isAppSettingsViewShowing = true
                    }
                    let impactMed = UIImpactFeedbackGenerator(style: .soft)
                    impactMed.impactOccurred()
                }) {
                    ZStack {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.black.opacity(0.5))
                    }

                }
                .padding()
                .frame(width: 60, height: 60)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color(red: 0.729, green: 0.725, blue: 0.71), Color(red: 1, green: 0.98, blue: 0.933)]), startPoint: .top, endPoint: .bottom)
                )
                .cornerRadius(50)
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
                            lineWidth: 3
                        )
                        .blendMode(.overlay)
                    //.opacity(0.3)
                )
                .pressAnimation()
                .padding(2)
            }
            .background(RoundedRectangle(cornerRadius: 50)
                .fill(Color.black))
            .shadow(color: Color.black.opacity(0.5), radius: 3, x: 0, y: 0)
        }
        .padding(.top, 20)
    }
    
    private var voiceSetupSheet: some View {
        ZStack {
            if let activeModal {
                switch activeModal {
                    case .voiceSettingsModal:
                        showVoiceSettingsModal(keyboardResponder: keyboardResponder)
                }
            }
        }
    }
    
    private var appSettingsSheet: some View {
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
    
    private var cornerTick: some View {
        Image(.cornerTick)
            .resizable()
            .scaledToFit()
            .frame(width: 125, height: 125)
            .alignmentGuide(HorizontalAlignment.leading) { d in d[.leading] }
            .alignmentGuide(VerticalAlignment.bottom) { d in d[.bottom] }
    }
    
    private var topTick: some View {
        Image(.topTick)
        .resizable()
        .scaledToFit()
        .frame(width: 125, height: 125)
        .alignmentGuide(HorizontalAlignment.center) { d in d[.leading] + d.width / 2 }
        .alignmentGuide(VerticalAlignment.top) { d in
            let dynamicIslandHeight: CGFloat = 67 
            return d[.top] + dynamicIslandHeight
        }
    }
    
    // Shadows, borders, etc
    private var borderShadow: some View {
        RoundedRectangle(cornerRadius: 55)
            .stroke(Color(red: 0.655, green: 0.627, blue: 0.569),lineWidth: 2)
            .shadow(color: Color(red: 0.655, green: 0.627, blue: 0.569),radius: 4, x: 0, y: 0)
            .clipShape(RoundedRectangle(cornerRadius: 55))
        
            .shadow(color: Color.black, radius: 3, x: 0, y: 0)
            .clipShape(RoundedRectangle(cornerRadius: 55))
    }
    
    private var backgroundColor: some View {
        Color(red: 1, green: 0.98, blue: 0.933)
    }
    
    private var backgroundNoise: some View {
        Image(.bgNoise)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .opacity(0.5)
    }
    
    private var whiteBorder: some View {
        RoundedRectangle(cornerRadius: 55)
            .strokeBorder(LinearGradient(gradient: Gradient(colors: [.white.opacity(1), .white.opacity(1)]), startPoint: .leading, endPoint: .trailing), lineWidth: 1)
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
        }
    }
}

#Preview("Main View") {
    MainView(
        isAppSettingsViewShowing: .constant(false),
        isModalStepTwoEnabled: .constant(false)
    )
}

#Preview("App Settings") {
    MainView(
        isAppSettingsViewShowing: .constant(true),
        isModalStepTwoEnabled: .constant(false)
    )
}
