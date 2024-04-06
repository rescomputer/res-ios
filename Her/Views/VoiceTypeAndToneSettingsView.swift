//
//  VoiceTypeAndToneSettingsView.swift
//  Her
//
//  Created by Steven Sarmiento on 4/6/24.
//

import SwiftUI

struct VoiceTypeAndToneSettingsView: View {
    var dismissAction: () -> Void
    @Binding var activeModal: MainView.ActiveModal?
    @Binding var selectedOption: Option?
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
                    
                    Text("Voice Type & Tone")
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

                    //TODO add images or video of what the final widgets look like
                    ZStack {
                        Image("lockscreen-widget-topper")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(15)
                            .padding(.bottom, 5)
                        
                        // VStack {
                        //     Text("Add a widget to your lock screen to access Her quickly on the go.")
                        //         .bold()
                        //         .font(.system(size: 18, design: .rounded))
                        //         .foregroundColor(Color.white.opacity(0.7))
                        //         .multilineTextAlignment(.center)
                        //         .frame(maxWidth: .infinity)
                        // }
                    }
                    .frame(maxWidth: .infinity, maxHeight: 120, alignment: .center)

                    VStack {
                        VoiceTypeAndToneView(activeModal: $activeModal, selectedOption: $selectedOption, callManager: callManager, keyboardResponder: keyboardResponder){
                            withAnimation(.easeOut(duration: 0.15)) {
                                self.dismissAction()                        
                            }
                        }
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
