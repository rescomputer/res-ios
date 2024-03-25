//
//  AppSettingsView.swift
//  Her
//
//  Created by Steven Sarmiento on 3/21/24.
//

import Foundation
import SwiftUI
import UIKit 
import AVFoundation

struct AppSettingsView: View {
    @Binding var isPresented: Bool
    @State private var isMicrophoneEnabled = false
    @State private var showingSettingsAlert = false
    @State private var infoModal: InfoModal?

    
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
                    .frame(height: 50)
                
                HStack {
                    Button(action: {
                        isPresented = false
                        let impactMed = UIImpactFeedbackGenerator(style: .soft)
                        impactMed.impactOccurred()
                    }) {
                        HStack {
                            Image(systemName: "xmark")
                                .font(.system(size: 20))
                                .bold()
                                .foregroundColor(.white.opacity(0.3))
                        }
                    }
                    Spacer()
                    
                    Text("Settings")
                        .bold()
                        .font(.system(size: 20, design: .rounded))
                        .foregroundColor(Color.white.opacity(0.8))
                    
                    
                    Spacer()

                    Button(action: {
                        self.infoModal = .aboutHerModal
                        let impactMed = UIImpactFeedbackGenerator(style: .soft)
                        impactMed.impactOccurred()
                    }) {
                        HStack {
                            Image(systemName: "info.circle.fill")
                                .font(.system(size: 20))
                                .bold()
                                .foregroundColor(.white.opacity(0.3))
                        }
                    }
                }
                .padding(.bottom, 20)

                VStack {
                     HStack {
                        Text("Permissions")
                            .bold()
                            .font(.system(size: 16))
                            .foregroundColor(Color.white.opacity(0.7))
                        Spacer()
                    }
                    CustomToggle(title: "Microphone", systemImageName: "mic.fill", isOn: $isMicrophoneEnabled)
                        .onChange(of: isMicrophoneEnabled) { newValue in
                            handleMicrophonePermission(isEnabled: newValue)
                        }
                    Text("You are only being recorded when you Start a Conversation. The app is never listening to you in the background.")
                        .font(.system(size: 14))
                        .padding(.vertical, 10)
                        .foregroundColor(Color.white.opacity(0.5))
                    HStack {
                        Text("Home Screen Widgets")
                            .bold()
                            .font(.system(size: 16))
                            .foregroundColor(Color.white.opacity(0.7))
                        Spacer()
                    }
                    .padding(.top, 20)
                    Text("You can add widgets to your home screen with a long-press anywhere among your apps & looking in the top left.")
                        .font(.system(size: 14))
                        .foregroundColor(Color.white.opacity(0.5))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 5)
                    //TODO add images or video of what the final widgets look like
                    Image("widget-example")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                        .padding(.top, 10)
                    }
                                        HStack {
                        Text("Lock Screen Widgets")
                            .bold()
                            .font(.system(size: 16))
                            .foregroundColor(Color.white.opacity(0.7))
                        Spacer()
                    }
                    .padding(.top, 20)
                    Text("You can add widgets to your lock screen by long pressing on it, selecting customise, tap on the lock screen, then Add Widget.")
                        .font(.system(size: 14))
                        .foregroundColor(Color.white.opacity(0.5))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 5)
                    //TODO add images or video of what the final widgets look like
                    Image("lock-screen-widget-example")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                        .padding(.top, 10)

                //TODO show if the widget is enabled?
                //TODO 
                Spacer()
                Spacer()


            }
            .padding()
            .onAppear {
                 checkMicrophonePermission()
            }
            .alert(isPresented: $showingSettingsAlert) { 
                Alert(
                    title: Text("Microphone Permission"),
                    message: Text("To disable the microphone, please go to Settings and turn off permissions for this app."),
                    primaryButton: .default(Text("Settings")) {
                        // Action to open app settings
                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString),
                            UIApplication.shared.canOpenURL(settingsUrl) else {
                            return
                        }
                        UIApplication.shared.open(settingsUrl)
                    },
                    secondaryButton: .cancel {
                        self.isMicrophoneEnabled = true
                    }
                )
            }          
        }
        .overlay {
            if let infoModal = infoModal {
                switch infoModal {
                case .aboutHerModal:
                    showAboutHerModal()
                }
            }
        }
    }
}



extension AppSettingsView {

    enum InfoModal {
        case aboutHerModal
    }

        private func showAboutHerModal() -> some View {

        HalfModalView(isShown: Binding<Bool>(
            get: { self.infoModal == .aboutHerModal },
            set: { newValue in
                if !newValue {
                    self.infoModal = nil
                }
            }
        ), onDismiss: {
            withAnimation(.easeInOut(duration: 0.15)) {
                self.infoModal = nil
            }
        }) {
            VStack{  
                ZStack {
                    HStack {
                        ZStack {
                            HStack {
                                Image(systemName: "info.circle.fill")
                                    .resizable()
                                    .foregroundColor(.black.opacity(0.05))
                                    .frame(width: 85, height: 85)
                                Spacer()
                            }
                            .offset(x: 10, y: -20)

                        
                            VStack(alignment: .leading) {
                                Text("We’re building Her for fun")
                                    .font(.system(size: 20, design: .rounded))
                                    .bold()
                                    .foregroundColor(Color.black.opacity(1))
                                    .padding(.bottom, 2)
                                Text("Learn more about “Her” and what it's all about.")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color.black.opacity(0.5))

                            }
                            .padding(.horizontal, 20)
                            .offset(x: -12)
                        }
                    }
                    .overlay(
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color.black.opacity(0.1)),
                        alignment: .bottom
                    )
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 0)
                        .fill(Color.black.opacity(0.05))
                        .frame(maxWidth: .infinity)
                        .frame(height: 130),
                        alignment: .bottom
                    )
                .overlay(
                    XMarkButton {
                        withAnimation(.easeOut(duration: 0.15)) {
                            self.infoModal = nil
                        }
                    }
                    .offset(x: -20, y: -5),
                    alignment: .topTrailing
                    )
                
                        ScrollView {
                           VStack(alignment:.leading, spacing: 10) {   
                             Text("""
                                "Her" is an open-source project aimed at exploring the intricacies of AI and human interaction.
                                """)
                            .font(.footnote)
                            .bold()
                            .foregroundColor(.black.opacity(0.6))

                            Text("The goal is to create a application where users can engage in meaningful conversations with the latest AI models. We want to offer power user features like interruption, speed selection, custom prompt modification, and a wide range of voices.")
                            .font(.footnote)
                            .foregroundColor(.black.opacity(0.6))

                            VStack(alignment: .leading){
                                Text("Her is powered by:")
                                    .font(.footnote)
                                    .bold()
                                    .foregroundColor(.black.opacity(0.6))

                                HStack(spacing: 20) {
                                    Link(destination: URL(string: "https://vapi.ai")!) {
                                        VStack {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(Color.black.opacity(0.05))
                                                    .frame(width: 64, height: 64)
                                                Image("vapi")
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 24, height: 24)
                                                    .padding(.top, 4)
                                                    .foregroundColor(Color.black.opacity(0.8))                                            
                                            }
                                            Text("VAPI")
                                                .font(.system(size: 10, weight: .bold))
                                                .foregroundColor(Color.black.opacity(0.3))
                                        }
                                    }
                                    .foregroundColor(.black.opacity(0.6))

                                    Link(destination: URL(string: "https://www.daily.co")!) {
                                        VStack {
                                            ZStack{
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(Color.black.opacity(0.05))
                                                    .frame(width: 64, height: 64)    
                                                Image("daily")
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 24, height: 24)
                                                    .padding(.top, 4)
                                                    .foregroundColor(Color.black.opacity(0.8))                                                                                         
                                            }
                                            Text("Daily")
                                                .font(.system(size: 10, weight: .bold))
                                                .foregroundColor(Color.black.opacity(0.3))                                        
                                        }
                                    }
                                    .foregroundColor(.black.opacity(0.6))

                                    Link(destination: URL(string: "https://deepgram.com")!) {
                                        VStack {
                                            ZStack{
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(Color.black.opacity(0.05))
                                                    .frame(width: 64, height: 64) 
                                                Image("deepgram")
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 24, height: 24)
                                                    .padding(.top, 4)
                                                    .foregroundColor(Color.black.opacity(0.8))                                              
                                            }
                                            Text("Deepgram")
                                                .font(.system(size: 10, weight: .bold))
                                                .foregroundColor(Color.black.opacity(0.3))                                        
                                        }
                                    }
                                    .foregroundColor(.black.opacity(0.6))

                                    Link(destination: URL(string: "https://openai.com")!) {
                                        VStack {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(Color.black.opacity(0.05))
                                                    .frame(width: 64, height: 64)                                             
                                                Image("openai")
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 24, height: 24)
                                                    .padding(.top, 4)
                                                    .foregroundColor(Color.black.opacity(0.8))  
                                            }
                                            Text("OpenAI")
                                                .font(.system(size: 10, weight: .bold))
                                                .foregroundColor(Color.black.opacity(0.3))                                        
                                        }
                                    }
                                    .foregroundColor(.black.opacity(0.6))
                                }
                            }

                            
                            Text("Your conversations are being routed through their servers. They are not private.")
                                .font(.footnote)
                                .foregroundColor(.black.opacity(0.6))
                            
                            Text("We never store personal information about you. However, the conversations are logged.")
                                .font(.footnote)
                                .foregroundColor(.black.opacity(0.6))
                            
                            Text("We will delete the logs on our end.")
                                .font(.footnote)
                                .foregroundColor(.black.opacity(0.6))
                         }
                         .padding()
                    }
                    .frame(maxHeight: 270)
                    
                    // Got it Button
                    Button {
                        self.infoModal = nil
                    } label: {
                        Text("Got it!")
                            .font(.system(.title2, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(red: 0.106, green: 0.149, blue: 0.149))
                            .cornerRadius(50)
                    }
                    .padding(.horizontal)
                    .pressAnimation()
                    
                }
            }
        }
    
    private func checkMicrophonePermission() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            isMicrophoneEnabled = true
        case .denied, .undetermined:
            isMicrophoneEnabled = false
        @unknown default:
            isMicrophoneEnabled = false
        }
    }

    private func handleMicrophonePermission(isEnabled: Bool) {
        if isEnabled {
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                DispatchQueue.main.async {
                    if granted {
                        self.isMicrophoneEnabled = true
                    } else {
                        self.isMicrophoneEnabled = false
                    }
                }
            }
        } else {
            showingSettingsAlert = true
        }
    }

}

