//
//  CustomTextPromptView.swift
//  Her
//
//  Created by Steven Sarmiento on 4/4/24.
//

import SwiftUI

struct CustomTextPromptView: View {
    @Binding var selectedOption: Option?
    @ObservedObject var callManager: CallManager
    @ObservedObject var keyboardResponder: KeyboardResponder
    @State private var currentStep: Int = 1

    var continueAction: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            Text("Custom Prompt")
                    .bold()
                    .font(.system(size: 14))
                    .foregroundColor(Color.black.opacity(0.5))
                    .padding(.top, 5)

                // CustomTextEditor
                HStack {
                    CustomTextEditor(text: $callManager.enteredText, isDisabled: callManager.callState != .ended)
                        .frame(height: 100)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 3)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(15)
                        .disabled(callManager.callState != .ended) // TODO get this to work with a custom element
                }

                if keyboardResponder.currentHeight == 0 {
                    // Text Label
                    Text("Prompt Presets")
                            .bold()
                            .font(.system(size: 14))
                            .foregroundColor(Color.black.opacity(0.5))
                            .padding(.top, 5)
                    
                    // OptionsMenu
                    HStack{
                        OptionsMenu(selectedOption: $selectedOption)
                            .frame(height: 70)
                            .onChange(of: selectedOption) {oldValue , newOption in
                                    if let newOption = newOption {
                                        callManager.enteredText = newOption.description
                                    }
                                }
                    }
                }
                // Continue Button
                // Button {
                //         continueAction()
                //     } label: {
                //         Text("Continue")
                //             .font(.system(.title2, design: .rounded))
                //             .fontWeight(.bold)
                //             .foregroundColor(.white)
                //             .padding()
                //             .frame(maxWidth: .infinity)
                //             .background(Color(red: 0.106, green: 0.149, blue: 0.149))
                //             .cornerRadius(50)
                //     }
                //     .pressAnimation()
                //     .padding(.top, 5)
                //     .buttonStyle(.plain)
                //     .opacity(1)
                //     .animation(nil)

                // Custom Continue Button
                ZStack {
                    RoundedRectangle(cornerRadius: 50)
                        .foregroundColor(Color(red: 0.106, green: 0.149, blue: 0.149))
                        .frame(height: 60)
                        .animation(nil)
                    Text("Continue")
                        .font(.system(.title2, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .onTapGesture {
                    continueAction()
                }
                .padding(.top, 5)
                .pressAnimation()
                .opacity(1)


        }
        .padding(.horizontal,20)
    }
}
