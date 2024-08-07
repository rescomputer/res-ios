//
//  VoiceTypeAndToneViewTe.swift
//  Res
//
//  Created by Steven Sarmiento on 5/18/24.
//

import SwiftUI

struct VoiceTypeAndToneSettingsTeView: View {
    var dismissAction: () -> Void
    @Binding var activeModal: MainViewTeenageEng.ActiveModal?
    @Binding var selectedOption: OptionTe?
    @Binding var isModalStepTwoEnabled: Bool
    @ObservedObject var callManager: CallManager
    @ObservedObject var keyboardResponder: KeyboardResponder

    var body: some View {

            ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [Color(red: 0.047, green: 0.071, blue: 0.071), Color(red: 0.047, green: 0.071, blue: 0.071)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .edgesIgnoringSafeArea(.all)

                VStack {
                Spacer()
                    .frame(height: 60)
                
                HStack {
                    Button(action: {
                        withAnimation(.easeOut(duration: 0.1)) {
                            self.dismissAction()
                        }
                        let impactMed = UIImpactFeedbackGenerator(style: .soft)
                        impactMed.impactOccurred()
                    }) {
                        HStack {
                            Image(systemName: "chevron.backward")
                                .font(.system(size: 20))
                                .bold()
                                .foregroundColor(.white.opacity(0.3))
                        }
                    }
                    Spacer()
                    
                    Text("Accents, Gender, Speed")
                        .bold()
                        .font(.system(size: 20, design: .rounded))
                        .foregroundColor(Color.white.opacity(0.8))
                    
                    
                    Spacer()

                    // Button(action: {
                    //     //action
                    //     let impactMed = UIImpactFeedbackGenerator(style: .soft)
                    //     impactMed.impactOccurred()
                    // }) {
                    //     HStack {
                    //         Image(systemName: "info.circle.fill")
                    //             .font(.system(size: 20))
                    //             .bold()
                    //             .foregroundColor(.white.opacity(0.3))
                    //     }
                    // }
                }
                .padding(.bottom, 20)

                    // ZStack {
                    //     Image("lockscreen-widget-topper")
                    //         .resizable()
                    //         .aspectRatio(contentMode: .fit)
                    //         .cornerRadius(15)
                    //         .padding(.bottom, 5)
                    // }
                    // .frame(maxWidth: .infinity, maxHeight: 120, alignment: .center)

                    VStack {
                        modalStepTwoToggle()

                        VoiceTypeAndToneTeView(
                            activeModal: $activeModal,
                            selectedOption: $selectedOption,
                            callManager: callManager,
                            keyboardResponder: keyboardResponder,
                            showSaveButton: false,
                            saveSettingsAction: {
                                withAnimation(.easeOut(duration: 0.15)) {
                                    self.dismissAction()
                                }
                            },
                            backgroundContext: .black
                        )
                    }
   

                 Spacer()
                 Spacer()
                 
                }
                .padding()
                .padding(.horizontal, 10)
                .slideLeft()

        }
    }
}

extension VoiceTypeAndToneSettingsTeView {

    private func modalStepTwoToggle() -> some View {
                    VStack{
                        HStack {
                            Text("")
                                .bold()
                                .font(.system(size: 16))
                                .foregroundColor(Color.white.opacity(0.7))
                            Spacer()
                        }
                        CustomToggle(
                            title: "Modal: Step Two",
                            systemImageName: isModalStepTwoEnabled ? "eye.slash.fill" : "eye.fill",
                            isOn: $isModalStepTwoEnabled
                        )
                        .contentTransition(.symbolEffect(.replace.offUp.byLayer))
                            
                        // Button(action: {
                        //     //self.infoModal = .recordingResModal
                        //     let impactMed = UIImpactFeedbackGenerator(style: .soft)
                        //     impactMed.impactOccurred()
                        // }) {
                        //     HStack {
                        //         Text("How does audio recording work?")
                        //             .font(.system(size: 14))
                        //             .foregroundColor(Color.white.opacity(0.3))
                        //         Image(systemName: "info.circle")
                        //             .font(.system(size: 14))
                        //             .foregroundColor(.white.opacity(0.3))
                        //     }
                        //     .padding(.vertical, 10)

                        // }
                        // .pressAnimation()
                    }
                    .padding(.bottom, 20)
    }
}

#Preview("Voice Type and Tone Settings View") {
    VoiceTypeAndToneSettingsTeView(
        dismissAction: {},
        activeModal: .constant(nil),
        selectedOption: .constant(nil),
        isModalStepTwoEnabled: .constant(false),
        callManager: CallManager(),
        keyboardResponder: KeyboardResponder()
    )
}

