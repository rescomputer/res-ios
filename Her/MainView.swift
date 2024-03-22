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
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isAppSettingsViewShowing = true
                    }
                }) {
                    Image(systemName: "gearshape.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(Color.white.opacity(0.5))
                        .padding()
                }
            }
            
            Spacer()
            VStack {
                Text("Let’s have a back & forth conversation 🙂")
                    .bold()
                    .font(.system(size: 30, design: .rounded))
                    .foregroundColor(Color.white.opacity(1))
                    .multilineTextAlignment(.center)
                Text("When you talk, I listen...")
                    .font(.system(size: 20))
                    .foregroundColor(Color.white.opacity(0.5))
            }
            .padding(.horizontal, 20)
            Spacer()

            // Start Button
            HStack {
                Button(action: {
                        self.activeModal = .voiceSettingsModal
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
            .padding(.horizontal)
            .padding(.bottom, 10)
            .pressAnimation()
            
            .disabled(callManager.callState == .loading)
            
        }
        .padding(.horizontal)
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
                    showVoiceSettingsModal()
                }
            }
            if isAppSettingsViewShowing {
                AppSettingsView(isPresented: $isAppSettingsViewShowing)
                    //.matchedGeometryEffect(id: "settings", in: animation)
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
        VStack(spacing: 5) {
            ZStack{
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.black.opacity(0.05))
                    .frame(width: 57, height: 57)
                Image(systemName: option.icon)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                    .padding(.top, 4)
                    .foregroundColor(Color.black.opacity(0.8))                
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(option.title)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(Color.black.opacity(0.2))

                // Text(option.description)
                //     .font(.system(size: 14))
                //     .foregroundColor(.gray)
                //     .fixedSize(horizontal: false, vertical: true)
                //     .frame(maxWidth: .infinity, alignment: .leading)
                //     .foregroundColor(Color(uiColor: .secondaryLabel))
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

    private func showVoiceSettingsModal() -> some View {

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
        }) {
            VStack(alignment: .center, spacing: 10){
                    HStack {
                        VStack {
                            Text("Who do you want to talk to?")
                                .font(.system(size: 20, design: .rounded))
                                .bold()
                                .foregroundColor(Color.black.opacity(1))
                                .padding(.bottom, 4)
                            Text("Choose a preset prompt or create your own persona to converse with.")
                                .font(.system(size: 14))
                                .foregroundColor(Color.black.opacity(0.5))
                        }
                        .alignmentGuide(.top, computeValue: { dimension in
                            dimension[.top]
                        })
                        // .padding(.top, 10)

                        Spacer()
                        VStack {
                            XMarkButton {
                                withAnimation {
                                    self.activeModal = nil
                                }
                            }
                        }
                        .alignmentGuide(.top, computeValue: { dimension in
                            dimension[.top]
                        })
                    }
                    .padding(.bottom, 20)
                    
                HStack {
                    Text("Custom Prompt")
                        .bold()
                        .font(.system(size: 14))
                        .foregroundColor(Color.black.opacity(0.5))
                    Spacer()
                }
                // CustomTextEditor
                HStack {
                    CustomTextEditor(text: $callManager.enteredText, isDisabled: callManager.callState != .ended)
                        .frame(height: 100)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(15)
                        .disabled(callManager.callState != .ended) // TODO get this to work with a custom element
                }

                // Text Label
                HStack {
                    Text("Prompt Presets")
                        .bold()
                        .font(.system(size: 14))
                        .foregroundColor(Color.black.opacity(0.5))
                    Spacer()

                }
                
                // OptionsMenu
                HStack{
                    OptionsMenu(selectedOption: $selectedOption)
                        .frame(height: 90)
                        .onChange(of: selectedOption) { newOption in
                                if let newOption = newOption {
                                    callManager.enteredText = newOption.description
                                }
                            }
                }
                
                // Pickers
                HStack {
                    Text("Voice Settings")
                        .bold()
                        .font(.system(size: 14))
                        .foregroundColor(Color.black.opacity(0.5))
                    Spacer()

                }
                HStack {
                    Menu {
                        Picker("Voice", selection: $callManager.voice) {
                            Text("🇺🇸 Alloy · Gentle Man").tag("alloy")
                            Text("🇺🇸 Echo · Deep Man").tag("echo")
                            Text("🇬🇧 Fable · Normal Man").tag("fable")
                            Text("🇺🇸 Onyx · Deeper Man").tag("onyx")
                            Text("🇺🇸 Nova · Gentle Woman").tag("nova")
                            Text("🇺🇸 Shimmer · Deep Woman").tag("shimmer")
                        }
                        .onChange(of: callManager.voice) { newVoice in
                            UserDefaults.standard.set(newVoice, forKey: "voice")
                        }
                    } label: {
                        HStack {
                            Text(callManager.voiceDisplayName) 
                                .font(.system(size: 14))
                                .foregroundColor(.black.opacity(1))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 8)
                        .background(Color.black.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: 50))
                        .overlay(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(Color.black.opacity(0.05), lineWidth: 1)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .pressAnimation()

                    Menu {
                        Picker("Speed", selection: $callManager.speed) {
                            Text("🐢 Slow").tag(0.3)
                            Text("💬 Normal").tag(1.0)
                            Text("🐇 Fast").tag(1.3)
                            Text("⚡️ Superfast").tag(1.5)
                        }
                        .onChange(of: callManager.speed) { newSpeed in
                            UserDefaults.standard.set(newSpeed, forKey: "speed")
                        }
                    } label: {
                        HStack {
                            Text(callManager.speedDisplayName) 
                                .font(.system(size: 14))
                                .foregroundColor(.black.opacity(1))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 8)
                        .background(Color.black.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: 50))
                        .overlay(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(Color.black.opacity(0.05), lineWidth: 1)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .pressAnimation()
                }
                
                // List {         
                //     // Voice Picker
                //     Picker("Voice", selection: $callManager.voice) {
                //         Text("🇺🇸 Alloy · Gentle Man").tag("alloy")
                //         Text("🇺🇸 Echo · Deep Man").tag("echo")
                //         Text("🇬🇧 Fable · Normal Man").tag("fable")
                //         Text("🇺🇸 Onyx · Deeper Man").tag("onyx")
                //         Text("🇺🇸 Nova · Gentle Woman").tag("nova")
                //         Text("🇺🇸 Shimmer · Deep Woman").tag("shimmer")
                //         .onReceive(callManager.$voice) { newVoice in
                //             UserDefaults.standard.set(newVoice, forKey: "voice")
                //         }
                //     }

                //     .disabled(callManager.callState != .ended)
                    
                //     // Speed Picker
                //     Picker("Speed", selection: $callManager.speed) {
                //         Text("🐢 Slow").tag(0.3)
                //         Text("💬 Normal").tag(1.0)
                //         Text("🐇 Fast").tag(1.3)
                //         Text("⚡️ Superfast").tag(1.5)
                //         .onReceive(callManager.$speed) {  newSpeed in
                //             UserDefaults.standard.set(newSpeed, forKey: "speed")
                //         }
                //     }
                //     .disabled(callManager.callState != .ended)
                // }
                // .frame(height: 88)
                // .listStyle(.plain)
                // .cornerRadius(15)
            }
            .padding(.horizontal, 25)
        }
    }

}

//#Preview {
//    MainView(isAppSettingsViewShowing: $isAppSettingsViewShowing)
//}
