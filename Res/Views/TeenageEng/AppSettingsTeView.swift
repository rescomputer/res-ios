//
//  AppSettingsView.swift
//  Res
//
//  Created by Steven Sarmiento on 3/21/24.
//

import Foundation
import SwiftUI
import UIKit
import AVFoundation

struct AppSettingsTeView: View {
    @EnvironmentObject var callManager: CallManager
    @Binding var isPresented: Bool

    @State private var isPrivacyModeEnabled = false
    @State private var isMicrophoneEnabled = false
    @State private var showingSettingsAlert = false
    @State private var infoModal: InfoModal?
    @State private var selectedSetting: SettingType?

    @Binding var activeModal: MainViewTeenageEng.ActiveModal?
    @Binding var selectedOption: OptionTe?
    @Binding var isModalStepTwoEnabled: Bool

    //@ObservedObject var callManager: CallManager
    @ObservedObject var keyboardResponder: KeyboardResponder

    let isDebugMode = Config.buildConfiguration == .debug
    
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
                            isPresented = false
                        }
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
                        self.infoModal = .aboutResModal
                        let impactMed = UIImpactFeedbackGenerator(style: .soft)
                        impactMed.impactOccurred()
                    }) {
                        HStack {
                            Image(systemName: "info.circle")
                                .font(.system(size: 20))
                                .bold()
                                .foregroundColor(.white.opacity(0.3))
                        }
                    }
                }
                .padding(.bottom, 20)

                VStack {

                    micPermissions()

                    privacySettings()

                    voiceTypeAndToneSettings()

                   // appCustomization()

                    widgetSettings()

                    }
                    Spacer()
                    Spacer()
                if isDebugMode {
                    signOutButton()
                }

            }
            .padding()
            .padding(.horizontal, 10)
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
        .slideDown()
        .overlay {
            if let infoModal = infoModal {
                switch infoModal {
                case .aboutResModal:
                    showAboutResModal()
                case .recordingResModal:
                    showRecordingResModal()
                case .privacyResModal:
                    showPrivacyResModal()
                }
            }
            if let selectedSetting = selectedSetting {
                switch selectedSetting {
                case .homeScreen:
                    HomeScreenWidgetGuideView(dismissAction: {
                            self.selectedSetting = nil
                        })
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .edgesIgnoringSafeArea(.all)
                        .transition(.opacity)
                case .lockScreen:
                    LockScreenWidgetGuideView(dismissAction: {
                            self.selectedSetting = nil
                        })
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .edgesIgnoringSafeArea(.all)
                        .transition(.opacity)
                case .voiceTypeAndTone:
                    VoiceTypeAndToneSettingsTeView(
                        dismissAction: {
                            self.selectedSetting = nil
                        },
                        activeModal: $activeModal,
                        selectedOption: $selectedOption,
                        isModalStepTwoEnabled: $isModalStepTwoEnabled,
                        callManager: callManager,
                        keyboardResponder: keyboardResponder
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
                    .transition(.opacity)
                case .appCustomization:
                    CustomizationView(dismissAction: {
                        self.selectedSetting = nil
                    })
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
                    .transition(.opacity)
                }   
            }
        }
    }
}

extension AppSettingsTeView {

     enum SettingType: Identifiable {
         case homeScreen, lockScreen, voiceTypeAndTone, appCustomization

         var id: Int {
             switch self {
             case .homeScreen: return 0
             case .lockScreen: return 1
             case .voiceTypeAndTone: return 2
             case .appCustomization: return 3
             }
         }
     }

    enum InfoModal {
        case aboutResModal
        case recordingResModal
        case privacyResModal
    }

    enum ModalHeightMultiplier {
        case aboutResModal
        case recordingResModal
        case privacyResModal

        var value: CGFloat {
            switch self {
            case .aboutResModal: return -0.02
            case .recordingResModal: return -0.02
            case .privacyResModal: return -0.02
            }
        }
    }

    private func signOutButton() -> some View {
        Button("Sign Out") {
            Task {
                do {
                    try await SupabaseManager.shared.signOut()
                    isPresented = false
                    print("Signed Out")
                } catch {
                    print("Signout failed: \(error.localizedDescription)")
                }
            }
        }
        .pressAnimation()
        .frame(maxWidth: .infinity)
        .frame(height: 54)
        .background(Color.red.opacity(0.4))
        .foregroundColor(.white)
        .cornerRadius(15)
        .font(.system(size: 17, weight: .semibold))
        .padding(.bottom, 20)
    }

    private func voiceTypeAndToneSettings() -> some View {
        VStack {
                HStack {
                    Text("Voice")
                        .bold()
                        .font(.system(size: 12))
                        .foregroundColor(Color.white.opacity(0.7))
                    Spacer()
                }
                CustomLinkView(iconName: "person.wave.2.fill", title: "Accents, Gender, Speed", action: {}, navigateTo: {
                    self.selectedSetting = .voiceTypeAndTone
                }, screenSize: UIScreen.main.bounds.size, offset: 0, minHeight: 100)
        }
        .padding(.bottom, 20)

    }

        private func appCustomization() -> some View {
        VStack {
                HStack {
                    Text("Customization")
                        .bold()
                        .font(.system(size: 12))
                        .foregroundColor(Color.white.opacity(0.7))
                    Spacer()
                }
                CustomLinkView(iconName: "theatermask.and.paintbrush.fill", title: "Skins, Icons, and More", action: {}, navigateTo: {
                    self.selectedSetting = .appCustomization
                }, screenSize: UIScreen.main.bounds.size, offset: 0, minHeight: 100)
        }
        .padding(.bottom, 20)

    }

    private func privacySettings() -> some View {
                    VStack{
                        CustomToggle(
                            title: "Privacy Mode",
                            systemImageName: callManager.hipaaEnabled ? "eye.slash.fill" : "eye.fill",
                            isOn: $callManager.hipaaEnabled,
                            infoAction: {
                                self.infoModal = .privacyResModal
                            }
                            )
                            .contentTransition(.symbolEffect(.replace.offUp.byLayer))
                            // .onChange(of: isMicrophoneEnabled) { oldValue ,newValue in
                            //     handleMicrophonePermission(isEnabled: newValue)
                            // }

                    }
                    .padding(.bottom, 20)

    }

    private func widgetSettings() -> some View {
        VStack {
                HStack {
                    Text("Tutorials")
                        .bold()
                        .font(.system(size: 12))
                        .foregroundColor(Color.white.opacity(0.7))
                    Spacer()
                }
                CustomLinkView(iconName: "rectangle.fill.on.rectangle.angled.fill", title: "Setup Home Screen Widgets", action: {}, navigateTo: {
                    self.selectedSetting = .homeScreen
                }, screenSize: UIScreen.main.bounds.size, offset: 0, minHeight: 100)
                CustomLinkView(iconName: "lock.rectangle.on.rectangle.fill", title: "Setup Lock Screen Widgets", action: {}, navigateTo: {
                    self.selectedSetting = .lockScreen
                }, screenSize: UIScreen.main.bounds.size, offset: 0, minHeight: 100)
        }
        .padding(.bottom, 20)

    }

    private func micPermissions() -> some View {
                    VStack{
                        HStack {
                            Text("Permissions")
                                .bold()
                                .font(.system(size: 12))
                                .foregroundColor(Color.white.opacity(0.7))
                            Spacer()
                        }
                        CustomToggle(
                            title: "Microphone",
                            systemImageName: isMicrophoneEnabled ? "mic.fill" : "mic.slash.fill",
                            isOn: $isMicrophoneEnabled,
                            infoAction: {
                                self.infoModal = .recordingResModal
                            }
                            )
                            .contentTransition(.symbolEffect(.replace.offUp.byLayer))
                            .onChange(of: isMicrophoneEnabled) { oldValue ,newValue in
                                handleMicrophonePermission(isEnabled: newValue)
                            }
                    }
    }

    private func showRecordingResModal() -> some View {
        HalfModalView(isShown: Binding<Bool>(
            get: { self.infoModal == .recordingResModal },
            set: { newValue in
                if !newValue {
                    self.infoModal = nil
                }
            }
        ), onDismiss: {
            withAnimation(.easeInOut(duration: 0.15)) {
                self.infoModal = nil
            }
        }, modalHeightMultiplier: AppSettingsTeView.ModalHeightMultiplier.recordingResModal.value
        ) {

            VStack {
                 ZStack {
                    HStack {
                        ZStack {
                            HStack {
                                Image(systemName: "waveform.badge.exclamationmark")
                                    .resizable()
                                    .foregroundColor(.black.opacity(0.05))
                                    .frame(width: 85, height: 85)
                                Spacer()
                            }
                            .offset(x: 10, y: -15)

                        
                            VStack(alignment: .leading) {
                                Text("Audio Permissions")
                                    .font(.system(size: 20, design: .rounded))
                                    .bold()
                                    .foregroundColor(Color.black.opacity(1))
                                    .padding(.bottom, 2)
                                Text("How we handle conversation audio within “Res”.")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color.black.opacity(0.5))

                            }
                            .padding(.horizontal, 20)
                            .offset(x: UIScreen.isLargeDevice ? -20 : 0)
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
                        withAnimation(.easeOut(duration: 0.1)) {
                            self.infoModal = nil
                        }
                    }
                    .offset(x: -20, y: 0),
                    alignment: .topTrailing
                    )
                
                    ScrollView {
                           VStack(alignment:.leading, spacing: 10) {
                             Text("""
                                Res uses AI to help make conversations more engaging and meaningful.
                                """)
                            .bold()
                            .font(.footnote)
                            .foregroundColor(.black.opacity(0.6))
                               
                            Text("Your conversations are being routed through different servers only when a call is started, this means they are not private.")
                                .font(.footnote)
                                .foregroundColor(.black.opacity(0.6))

                            VStack(alignment: .leading){
                                Text("Res is powered by:")
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
                                                Image(.vapi)
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
                                                Image(.daily)
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
                                                Image(.deepgram)
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
                                                Image(.openai)
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

                            
                            Text("We take user privacy very seriously and never store personal information about you. However, the conversations are logged.")
                                .font(.footnote)
                                .foregroundColor(.black.opacity(0.6))
                            
                            Text("All logs are deleted on our end daily.")
                                .font(.footnote)
                                .bold()
                                .foregroundColor(.black.opacity(0.6))
                         }
                        //  .padding(.top, 10)
                    }
                    .frame(maxHeight: 300)
                    .padding(.horizontal, 20)
                    // .applyScrollViewEdgeFadeLight()
                    
                    // Got it Button
                    VStack{
                        ZStack {
                                RoundedRectangle(cornerRadius: 50)
                                    .foregroundColor(Color(red: 0.106, green: 0.149, blue: 0.149))
                                    .frame(height: 60)
                                Text("Got it!")
                                    .font(.system(.title2, design: .rounded))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                            .onTapGesture {
                                self.infoModal = nil
                            }
                            .padding(.top, 5)
                            .pressAnimation()
                            .opacity(1)
                    }
                    .padding(.horizontal, 20)

            }
            .padding(.vertical)
            .background(
                    RoundedRectangle(cornerRadius: 40)
                        .fill(Color.white)
            )
        }
    }

    private func showAboutResModal() -> some View {

        HalfModalView(isShown: Binding<Bool>(
            get: { self.infoModal == .aboutResModal },
            set: { newValue in
                if !newValue {
                    self.infoModal = nil
                }
            }
        ), onDismiss: {
            withAnimation(.easeInOut(duration: 0.15)) {
                self.infoModal = nil
            }
        }, modalHeightMultiplier: AppSettingsTeView.ModalHeightMultiplier.aboutResModal.value
        ) {
            VStack{
                ZStack {
                    HStack {
                        ZStack {
                            HStack {
                                Image(systemName: "party.popper.fill")
                                    .resizable()
                                    .foregroundColor(.black.opacity(0.05))
                                    .frame(width: 85, height: 85)
                                Spacer()
                            }
                            .offset(x: 10, y: -15)

                        
                            VStack(alignment: .leading) {
                                Text("We’re building Res for fun")
                                    .font(.system(size: 20, design: .rounded))
                                    .bold()
                                    .foregroundColor(Color.black.opacity(1))
                                    .padding(.bottom, 2)
                                Text("Learn more about Res and what it's all about.")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color.black.opacity(0.5))

                            }
                            .padding(.horizontal, 20)
                            .offset(x: UIScreen.isLargeDevice ? -20 : 0)

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
                    .offset(x: -20, y: 0),
                    alignment: .topTrailing
                    )
                
                        VStack(alignment:.leading, spacing: 10) {
                             Text("""
                                "Res" is an open-source project aimed at exploring the intricacies of AI and human interaction.
                                """)
                            .font(.footnote)
                            .bold()
                            .foregroundColor(.black.opacity(0.6))

                            Text("The goal is to create a application where users can engage in meaningful conversations with the latest AI models. We want to offer power user features like interruption, speed selection, custom prompt modification, and a wide range of voices.")
                            .font(.footnote)
                            .foregroundColor(.black.opacity(0.6))
                         }
                         .frame(height: 150)
                         .padding(.horizontal, 20)
                    
                    // Got it Button
                    VStack{
                        ZStack {
                                RoundedRectangle(cornerRadius: 50)
                                    .foregroundColor(Color(red: 0.106, green: 0.149, blue: 0.149))
                                    .frame(height: 60)
                                Text("Got it!")
                                    .font(.system(.title2, design: .rounded))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                            .onTapGesture {
                                self.infoModal = nil
                            }
                            .padding(.top, 5)
                            .pressAnimation()
                            .opacity(1)
                    }
                    .padding(.horizontal, 20)

                    
            }
            .padding(.vertical)
            .background(
                    RoundedRectangle(cornerRadius: 40)
                        .fill(Color.white)
            )
        }
    }

    private func showPrivacyResModal() -> some View {

        HalfModalView(isShown: Binding<Bool>(
            get: { self.infoModal == .privacyResModal },
            set: { newValue in
                if !newValue {
                    self.infoModal = nil
                }
            }
        ), onDismiss: {
            withAnimation(.easeInOut(duration: 0.15)) {
                self.infoModal = nil
            }
        }, modalHeightMultiplier: AppSettingsTeView.ModalHeightMultiplier.aboutResModal.value
        ) {
            VStack{
                ZStack {
                    HStack {
                        ZStack {
                            HStack {
                                Image(systemName: "eye.slash.fill")
                                    .resizable()
                                    .foregroundColor(.black.opacity(0.05))
                                    .frame(width: 85, height: 85)
                                Spacer()
                            }
                            .offset(x: 10, y: -15)

                        
                            VStack(alignment: .leading) {
                                Text("Your Privacy is Paramount")
                                    .font(.system(size: 20, design: .rounded))
                                    .bold()
                                    .foregroundColor(Color.black.opacity(1))
                                    .padding(.bottom, 2)
                                Text("Learn more about how Res handles privacy with HIPPA")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color.black.opacity(0.5))

                            }
                            .padding(.horizontal, 20)
                            .offset(x: UIScreen.isLargeDevice ? -20 : 0)

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
                    .offset(x: -20, y: 0),
                    alignment: .topTrailing
                    )
                
                        VStack(alignment:.leading, spacing: 10) {
                             Text("""
                                Res is HIPPA enabled out of the box. Meaning that all conversations are able to be protected with HIPPA compliance. No recordings, no data is stored, and no data is shared.
                                """)
                            .font(.footnote)
                            .bold()
                            .foregroundColor(.black.opacity(0.6))

                            Text("The goal is to create a application where users can engage in meaningful conversations with the latest AI models with out the need to worry about whether their data or conversations are being stored or how they would be used. ")
                            .font(.footnote)
                            .foregroundColor(.black.opacity(0.6))
                         }
                         .frame(height: 150)
                         .padding(.horizontal, 20)

                    
                    // Got it Button
                    VStack{
                        ZStack {
                                RoundedRectangle(cornerRadius: 50)
                                    .foregroundColor(Color(red: 0.106, green: 0.149, blue: 0.149))
                                    .frame(height: 60)
                                Text("Got it!")
                                    .font(.system(.title2, design: .rounded))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                            .onTapGesture {
                                self.infoModal = nil
                            }
                            .padding(.top, 5)
                            .pressAnimation()
                            .opacity(1)
                    }
                    .padding(.horizontal, 20)

                    
            }
            .padding(.vertical)
            .background(
                    RoundedRectangle(cornerRadius: 40)
                        .fill(Color.white)
            )
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


#Preview("App Settings View") {
    AppSettingsTeView(
        isPresented: .constant(true),
        activeModal: .constant(nil), // Set to nil if there's no appropriate case
        selectedOption: .constant(nil),
        isModalStepTwoEnabled: .constant(false),
        //callManager: CallManager(),
        keyboardResponder: KeyboardResponder()
    )
}

struct Option: Identifiable, Equatable, Hashable {
    let id = UUID()
    let icon: String
    let title: String
    let description: String
}
