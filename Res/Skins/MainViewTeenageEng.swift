//
//  MainViewTeenageEng.swift
//  Res
//
//  Created by Steven Sarmiento on 5/18/24.
//

import SwiftUI
import UIKit
import ActivityKit

struct MainViewTeenageEng: View {
    @FocusState private var isTextFieldFocused: Bool
    
    @StateObject private var callManager = CallManager()
    @StateObject private var keyboardResponder = KeyboardResponder()
    
    @Binding var isAppSettingsViewShowing: Bool
    @Binding var isModalStepTwoEnabled: Bool
    
    @State private var drawingHeight = true
    @State private var selectedOption: Option?
    @State private var activeModal: ActiveModal?
    @State private var teScreenState: TeScreenState = .textFirstScreen

    var body: some View {
        ZStack {
            backgroundGradient

            VStack {
                topTickTe
                teScreen
                teenageEngGrill
                Spacer()
                mainButtons
            }
            .padding()
            .padding(.bottom)
            
            .overlay(borderShadow)
            
            .background(backgroundColor)
            
            .overlay(backgroundNoise)
            .overlay(whiteBorder)
            
            .clipShape(RoundedRectangle(cornerRadius: 25))
        }
        .ignoresSafeArea(edges: .bottom)
        
        .onAppear { callManager.setupVapi() }
        .overlay { voiceSetupSheet }
        .overlay { if isAppSettingsViewShowing { appSettingsSheet } }
    }
    
    // Components
    private var backgroundGradient: some View {
        LinearGradient(
            gradient: screenGradient,
            startPoint: .top,
            endPoint: .bottom
        )
        .edgesIgnoringSafeArea(.all)
    }
    
    private var teScreen: some View {
        ZStack {
            switch teScreenState {
            case .textFirstScreen:
                VStack {
                    Text("Text First Screen")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                }
            case .voiceSettingsScreen:
                VoiceSettingsTeView(
                    activeModal: $activeModal,
                    selectedOption: $selectedOption,
                    isModalStepTwoEnabled: $isModalStepTwoEnabled,
                    callManager: callManager,
                    keyboardResponder: keyboardResponder
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 300)
        .background(LinearGradient( gradient: screenGradient, startPoint: .top, endPoint: .bottom))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            Image(.bgNoise)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .opacity(0.5)
        )
        .overlay(
                  // Inner light stroke
                  RoundedRectangle(cornerRadius: 20, style: .continuous)
                     .strokeBorder(
                        LinearGradient(
                           colors: [
                              Color.white,
                              Color.white.opacity(0),
                              Color.white.opacity(0),
                              Color.white.opacity(0),
                              Color.white.opacity(0.3)
                           ],
                           startPoint: .bottom,
                           endPoint: .top
                        ),
                        lineWidth: 4
                     )
                     .blendMode(.plusLighter)
                     .opacity(0.3)
        )
        .overlay(
                  // Inner light stroke
                  RoundedRectangle(cornerRadius: 20, style: .continuous)
                     .strokeBorder(
                        LinearGradient(
                           colors: [
                              Color.black,
                              Color.black,
                           ],
                           startPoint: .bottom,
                           endPoint: .top
                        ),
                        lineWidth: 1
                     )
                     .blendMode(.plusLighter)
                     .opacity(0.3)
        )
        .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 3)
    }
    
    private var screenGradient: Gradient {
        Gradient(colors: [
            Color(red: 0.051, green: 0.043, blue: 0.047),
            Color(red: 0.051, green: 0.043, blue: 0.047),  
            Color(red: 0.051, green: 0.043, blue: 0.047), 
            Color(red: 0.051, green: 0.043, blue: 0.047),
            Color(red: 0.137, green: 0.137, blue: 0.137)
            ])
    }
    
    private var teenageEngGrill: some View {
        Image(.teenageEngGrill)
            .resizable()
            .scaledToFill()
            .frame(width: 260, height: 260)
            .padding(.vertical, 10)
    }
    
    private var mainButtons: some View {
        HStack { 
            brainButton
            Spacer()
            callButton
            Spacer()
            appSettingsButton
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)

    }

    private var callButton: some View {
            
            ZStack {
                // Start Button
                ZStack {
                    callManager.buttonText
                        .fadeInEffect()
                }
                .font(.system(size: 42))
                .frame(width: 110, height: 110)
                .background(callManager.buttonGradient)
                .cornerRadius(100)
                .overlay(
                    // Inner light stroke
                    RoundedRectangle(cornerRadius: 100, style: .continuous)
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
                        .blur(radius: 1.0)
                )
                
                .onTapGesture {
                    Task { await callManager.handleCallAction() }
                    let impactMed = UIImpactFeedbackGenerator(style: .soft)
                    impactMed.impactOccurred()
                }
                .pressAnimation()
                .padding(2)
            }
            .background(RoundedRectangle(cornerRadius: 100).fill(Color.black))
            .shadow(color: Color(red: 0.957, green: 0.812, blue: 0.714).opacity(0.4), radius: 3, x: 0, y: -4)
            .shadow(color: Color(red: 0.506, green: 0.173, blue: 0.02).opacity(0.4), radius: 7, x: 0, y: 7)
            .shadow(color: Color(red: 0.506, green: 0.173, blue: 0.02).opacity(0.6), radius: 3, x: 0, y: 2)
            
            .disabled(callManager.callState == .loading) 
    }
    
    private var appSettingsButton: some View {
            
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
                        Image(systemName: "gear")
                            .font(.system(size: 20))
                            .foregroundColor(.black.opacity(0.7))
                    }

                }
                .padding()
                .frame(width: 60, height: 60)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color(red: 0.937, green: 0.933, blue: 0.914), Color(red: 0.867, green: 0.871, blue: 0.816)]), startPoint: .top, endPoint: .bottom)
                )
                .cornerRadius(35)
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
                        .blur(radius: 1.0)

                )
                .pressAnimation()
                .padding(1)
            }
            .background(RoundedRectangle(cornerRadius: 50)
                .fill(Color.black))
            .shadow(color: Color.black.opacity(0.3), radius: 3, x: 0, y: 3)
            .shadow(color: Color.white.opacity(0.9), radius: 3, x: 0, y: -3)
    }

     private var brainButton: some View {
            //personality & voice
            ZStack {
                Button(action: {
                    self.teScreenState = .voiceSettingsScreen
                   // self.activeModal = .voiceSettingsModal
                    let impactMed = UIImpactFeedbackGenerator(style: .soft)
                    impactMed.impactOccurred()
                }) {
                    ZStack {
                        Image(systemName: "waveform")
                            .font(.system(size: 20))
                            .foregroundColor(.black.opacity(0.7))
                    }
                }
                .padding()
                .frame(width: 60, height: 60)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color(red: 0.937, green: 0.933, blue: 0.914), Color(red: 0.867, green: 0.871, blue: 0.816)]), startPoint: .top, endPoint: .bottom)
                )
                .cornerRadius(35)
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
                        .blur(radius: 1.0)
                )
                .pressAnimation()
                .padding(1)
            }
            .background(RoundedRectangle(cornerRadius: 50)
                .fill(Color.black))
            .shadow(color: Color.black.opacity(0.3), radius: 3, x: 0, y: 3)
            .shadow(color: Color.white.opacity(0.9), radius: 3, x: 0, y: -3)

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
        AppSettingsTeView(
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

    private var topTickTe: some View {
        HStack{
            Image(.resMarkerTe)
                .resizable()
                .scaledToFit()
                .frame( height:12)
            Spacer()
            Text("1.0.12")
                .font(.system(size: 14, design: .monospaced))
                .fontWeight(.bold)
                .foregroundColor(.black.opacity(0.3))
        }
        .padding(.horizontal, 20)

    }
    
    //Shadows, borders, etc
    private var borderShadow: some View {
        RoundedRectangle(cornerRadius: 25)
            .stroke(Color(red: 0.655, green: 0.627, blue: 0.569),lineWidth: 2)
            .shadow(color: Color(red: 0.655, green: 0.627, blue: 0.569),radius: 4, x: 0, y: 0)
            .clipShape(RoundedRectangle(cornerRadius: 25))
        
            .shadow(color: Color.black, radius: 3, x: 0, y: 0)
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .opacity(0.4)
    }
    
    private var backgroundColor: some View {
        Color(red: 0.91, green: 0.914, blue: 0.89)
    }
    
    private var backgroundNoise: some View {
        Image(.bgNoise)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .opacity(0.5)
    }
    
    private var whiteBorder: some View {
        RoundedRectangle(cornerRadius: 25)
            .strokeBorder(LinearGradient(gradient: Gradient(colors: [.white.opacity(1), .white.opacity(1)]), startPoint: .leading, endPoint: .trailing), lineWidth: 1)
    }
}

extension MainViewTeenageEng {
    enum TeScreenState {
        case textFirstScreen
        case voiceSettingsScreen
    }
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
        }, modalHeightMultiplier: MainViewTeenageEng.ModalHeightMultiplier.voiceSettingsModal.value
        ) {
            VoiceSettingsTeView(
                activeModal: $activeModal,
                selectedOption: $selectedOption,
                isModalStepTwoEnabled: $isModalStepTwoEnabled,
                callManager: callManager,
                keyboardResponder: keyboardResponder)
        }
    }
}

#Preview("Main View") {
    MainViewTeenageEng(
        isAppSettingsViewShowing: .constant(false),
        isModalStepTwoEnabled: .constant(false)
    )
}

#Preview("App Settings") {
    MainViewTeenageEng(
        isAppSettingsViewShowing: .constant(true),
        isModalStepTwoEnabled: .constant(false)
    )
}

