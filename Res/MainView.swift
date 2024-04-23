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
                VStack {
                    Spacer()
                        .frame(height: 43) 
                        
                        VStack {

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
                            ZStack {
                                VStack {
                                    Image("roboto")
                                        .resizable()
                                        .frame(maxWidth: 100, maxHeight: 100)
                                        .padding(.bottom, 10)
                                }   
                            }
                            .frame(maxWidth: .infinity, maxHeight: 500)
                            .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color(red: 0.067, green: 0.094, blue: 0.063), Color(red: 0.071, green: 0.192, blue: 0.078)]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )  
                                )
                                .overlay(
                                    Image("bg-noise")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .opacity(0.5)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 30)
                                        .strokeBorder(LinearGradient(gradient: Gradient(colors: [.black, .black]), startPoint: .top, endPoint: .trailing), lineWidth: 12)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 30)
                                        .strokeBorder(LinearGradient(gradient: Gradient(colors: [Color(red: 0.878, green: 0.863, blue: 0.824), Color(red: 1, green: 0.98, blue: 0.933)]), startPoint: .top, endPoint: .trailing), lineWidth: 10)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 30))
                                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 0)


                                Spacer()
                                    .frame(height: 30)

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
                                            Image("bg-noise")
                                                .resizable()
                                                .frame(width: .infinity, height: 60)
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
                            Spacer()
                        }
                        .padding()
                        .padding(.horizontal, 10)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                        .overlay(
                            Image("corner-tick")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100) // Adjust the size as needed
                                .alignmentGuide(HorizontalAlignment.leading) { d in d[.leading] }
                                .alignmentGuide(VerticalAlignment.bottom) { d in d[.bottom] },
                            alignment: .bottomLeading
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 55)
                                .stroke(Color(red: 0.655, green: 0.627, blue: 0.569), 
                                        lineWidth: 2)
                                .shadow(color: Color(red: 0.655, green: 0.627, blue: 0.569), 
                                        radius: 4, x: 0, y: 0)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 55)
                                )
                                .shadow(color: Color.black, radius: 3, x: 0, y: 0)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 55)
                                )
                        )
                        .background(Color(red: 1, green: 0.98, blue: 0.933))
                        .overlay(
                            Image("bg-noise")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .opacity(0.5)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 55)
                                .strokeBorder(LinearGradient(gradient: Gradient(colors: [.white.opacity(1), .white.opacity(1)]), startPoint: .leading, endPoint: .trailing), lineWidth: 1)
                        )  
                        .clipShape(RoundedRectangle(cornerRadius: 55))     
                }
                .onAppear { callManager.setupVapi() }
                .edgesIgnoringSafeArea(.all)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.black, Color.black]),
                        startPoint: .top,
                        endPoint: .bottom
                    )   

                )
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
