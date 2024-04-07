//
//  CustomTextPromptView.swift
//  Her
//
//  Created by Steven Sarmiento on 4/4/24.
//

import SwiftUI

struct CustomTextPromptView: View {
    @Binding var activeModal: MainView.ActiveModal?
    @Binding var selectedOption: Option?
    @Binding var isModalStepTwoEnabled: Bool
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

                // Custom Continue Button
                ZStack {
                    RoundedRectangle(cornerRadius: 50)
                        .foregroundColor(Color(red: 0.106, green: 0.149, blue: 0.149))
                        .frame(height: 60)
                        .animation(nil)
                    if isModalStepTwoEnabled {
                       Text("Save Settings")
                        .font(.system(.title2, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    } else {
                       Text("Continue")
                        .font(.system(.title2, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    } 
                }
                .onTapGesture {
                    if isModalStepTwoEnabled {
                        self.activeModal = nil
                    } else {
                        continueAction()
                    }                
                }
                .padding(.top, 5)
                .pressAnimation()
                .opacity(1)


        }
        .padding(.horizontal,20)
    }
}

struct Option: Identifiable, Equatable, Hashable {
    let id = UUID()
    let icon: String
    let title: String
    let description: String
}

struct OptionRow: View {
    let option: Option
    @Binding var selectedOption: Option?

    var body: some View {
        VStack(spacing: 2) {
            ZStack{
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.05))
                    .frame(width: 50, height: 50)
                Image(systemName: option.icon)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                    .padding(.top, 4)
                    .foregroundColor(Color.black.opacity(0.8))
            }
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(selectedOption == option ? Color.blue : Color.clear, lineWidth: 2)
                    .padding(-4)

            )
            
            // .overlay(selectedOption == option ? 
            //     RoundedRectangle(cornerRadius: 12)
            //         .stroke(Color.blue.opacity(0.8), lineWidth: 4)
            //         .padding(-4)
            //         : nil
            // )
            
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
                    OptionRow(option: option, selectedOption: $selectedOption)
                        .onTapGesture {
                            selectedOption = option
                        }
                        .id(option.id)
                }
            }
        }
        .frame(maxHeight: 100)
        .padding(.horizontal, 10)
    }
}