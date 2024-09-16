//
//  SettingsView.swift
//  Res
//
//  Created by Steven Sarmiento on 9/15/24.
//

import SwiftUI

struct SettingsView: View {
    @Binding var isActive: Bool
    @Environment(\.openURL) var openURL

    @ObservedObject var callManager: CallManagerNewDirection
    @State private var selectedVoiceProvider = "default"
    @State private var selectedAIModel = "gpt-4o"
    @State private var selectedLanguage = "en"
    @State private var silenceTimeout = 120.0
    @State private var maxCallDuration = 1800.0
    @State private var wordsToInterrupt = 1.0
    @State private var voiceSpeed = 1.0
    @State private var buildNumber: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "Unknown"
    
    let voiceProviders = ["default", "elevenlabs", "azure"] 
    let aiModels = ["gpt-4o", "gpt-4-0125-preview", "gpt-4-1106-preview"]
    let languages = ["en", "es", "fr", "de"] 

    var body: some View {
        NavigationView {
            Form {
                Section(header: HStack {
                    Text("Speech Speed")
                    Spacer()
                    Text(String(format: "%.1fx", voiceSpeed))
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                        .contentTransition(.numericText())
                        .transaction { t in
                            t.animation = .default
                        }  
                }) {
                    HStack {
                        Image(systemName: "tortoise.fill")
                            .foregroundColor(.black.opacity(0.3))
                        Slider(value: $voiceSpeed, in: 0.5...2.0, step: 0.1)
                        Image(systemName: "hare.fill")
                            .foregroundColor(.black.opacity(0.3))
                    }
                }

                Section(header: Text("Model Settings")) {
                    Toggle("Privacy Mode", isOn: $callManager.hipaaEnabled)
                        .tint(.orange)

                    Picker("Voice Provider", selection: $selectedVoiceProvider) {
                        ForEach(voiceProviders, id: \.self) {
                            Text($0)
                        }
                    }
                    
                    Picker("AI Model", selection: $selectedAIModel) {
                        ForEach(aiModels, id: \.self) {
                            Text($0)
                        }
                    }
                    
                    Picker("Transcriber Language", selection: $selectedLanguage) {
                        ForEach(languages, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section(header: Text("Advanced Settings")) {
                    HStack {
                        Text("Silence Timeout")
                        Spacer()
                        Text("\(Int(silenceTimeout)) seconds")
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                            .contentTransition(.numericText())
                            .transaction { t in
                                t.animation = .default
                        } 
                    }
                    Slider(value: $silenceTimeout, in: 30...300, step: 10)
                    
                    HStack {
                        Text("Max Call Duration")
                        Spacer()
                        Text("\(Int(maxCallDuration / 60)) minutes")
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                            .contentTransition(.numericText())
                            .transaction { t in
                                t.animation = .default
                        } 
                    }
                    Slider(value: $maxCallDuration, in: 300...3600, step: 60)
                    
                    HStack {
                        Text("Words to Interrupt")
                        Spacer()
                        Text("\(Int(wordsToInterrupt))")
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                            .contentTransition(.numericText())
                            .transaction { t in
                                t.animation = .default
                        } 
                    }
                    Slider(value: $wordsToInterrupt, in: 1...10, step: 1)
                }

                Section(header: Text("About")) {
                    Button("Contact Us") {
                        // Implement contact action (e.g., open email)
                        if let url = URL(string: "mailto:support@resapp.com") {
                            openURL(url)
                        }
                    }
                    
                    Button("Twitter") {
                        if let url = URL(string: "https://twitter.com/resapp") {
                            openURL(url)
                        }
                    }
                    
                    Button("Discord") {
                        if let url = URL(string: "https://discord.gg/resapp") {
                            openURL(url)
                        }
                    }
                    
                    Button("Privacy Policy") {
                        if let url = URL(string: "https://resapp.com/privacy") {
                            openURL(url)
                        }
                    }
                    
                    Button("Terms of Use") {
                        if let url = URL(string: "https://resapp.com/terms") {
                            openURL(url)
                        }
                    }
                    
                    HStack {
                        Text("Build Number")
                        Spacer()
                        Text(buildNumber)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .background(Color(red: 0.945, green: 0.945, blue: 0.918))
            .scrollContentBackground(.hidden) 
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        isActive = false
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.orange)
                        Text("RES")
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                            .foregroundColor(.orange)
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("Settings")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(Color(red: 0.271, green: 0.267, blue: 0.2))
                }
            }
        }
        .accentColor(.orange)
        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
    }
}