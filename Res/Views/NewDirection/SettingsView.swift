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

    @State private var isSubscribed: Bool = false
    // @State private var selectedVoiceProvider = "default"
    // @State private var selectedAIModel = "gpt-4o"
    // @State private var selectedLanguage = "en"
    // @State private var silenceTimeout = 120.0
    // @State private var maxCallDuration = 1800.0
    // @State private var wordsToInterrupt = 1.0
    @State private var voiceSpeed = 1.0
    @State private var buildNumber: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "Unknown"
    
    // let voiceProviders = ["default", "elevenlabs", "azure"] 
    // let aiModels = ["gpt-4o", "gpt-4-0125-preview", "gpt-4-1106-preview"]
    // let languages = ["en", "es", "fr", "de"] 

    var body: some View {
        NavigationView {
            Form {
                if isSubscribed {
                    membershipSection
                } else {
                    subscriptionCard
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                }

                Section(header: HStack {
                    Text("Voice Speed")
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


                Section(header: Text("Support")) {
                    Button(action: {
                        if let url = URL(string: "mailto:support@resapp.com") {
                            openURL(url)
                        }
                    }) {
                        HStack {
                            Text("Feedback")
                                .font(.system(size: 16, weight: .regular, design: .rounded))
                                .foregroundColor(.black)
                            Spacer()
                            Image(systemName: "ellipsis")
                                    .rotationEffect(.degrees(90))
                                    .foregroundColor(.gray)
                        }       
                    }

                    Button(action: {
                        // RATE REZ
                    }) {
                        HStack {
                            Text("Review RES")
                                .font(.system(size: 16, weight: .regular, design: .rounded))
                                .foregroundColor(.black)
                            Spacer()
                            Image(systemName: "link")
                                    .foregroundColor(.gray)
                            }
                        }
                }                

                Section(header: Text("Community")) {
                    
                    Button(action: {
                        if let url = URL(string: "https://twitter.com/resapp") {
                            openURL(url)
                        }
                    }) {
                        HStack {
                            Text("Twitter")
                                .font(.system(size: 16, weight: .regular, design: .rounded))
                                .foregroundColor(.black)
                            Spacer()
                            Image(systemName: "link")
                                    .foregroundColor(.gray)
                            }
                        }
                
                    Button(action: {
                        if let url = URL(string: "https://discord.gg/resapp") {
                            openURL(url)
                        }
                    }) {
                        HStack {
                            Text("Discord")
                                .font(.system(size: 16, weight: .regular, design: .rounded))
                                .foregroundColor(.black)
                            Spacer()
                            Image(systemName: "link")
                                    .foregroundColor(.gray)
                            }
                        }

                }

                Section(header: Text("About")) {
                    Button(action: {
                        // Action for RES Pro (to be implemented)
                    }) {
                        HStack {
                            Text("Who built RES?")
                                .font(.system(size: 16, weight: .regular, design: .rounded))
                                .foregroundColor(.black)
                            Spacer()
                            Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                    
                    HStack {
                        Text("Build Number")
                        Spacer()
                        Text(buildNumber)
                            .foregroundColor(.secondary)
                    }
                }

                Section(header: Text("Legal")) {
                    Button(action: {
                        if let url = URL(string: "https://resapp.com/privacy") {
                            openURL(url)
                        }
                    }) {
                        HStack {
                            Text("Privacy Policy")
                                .font(.system(size: 16, weight: .regular, design: .rounded))
                                .foregroundColor(.black)
                            Spacer()
                            Image(systemName: "link")
                                    .foregroundColor(.gray)
                            }
                        }
                    
                    Button(action: {
                        if let url = URL(string: "https://resapp.com/terms") {
                            openURL(url)
                        }
                    }) {
                        HStack {
                            Text("Terms of Use")
                                .font(.system(size: 16, weight: .regular, design: .rounded))
                                .foregroundColor(.black)
                            Spacer()
                            Image(systemName: "link")
                                    .foregroundColor(.gray)
                            }
                        }
                }

                // Section(header: Text("Model Settings")) {
                //     Toggle("Privacy Mode", isOn: $callManager.hipaaEnabled)
                //         .tint(.orange)

                //     Picker("Voice Provider", selection: $selectedVoiceProvider) {
                //         ForEach(voiceProviders, id: \.self) {
                //             Text($0)
                //         }
                //     }
                    
                //     Picker("AI Model", selection: $selectedAIModel) {
                //         ForEach(aiModels, id: \.self) {
                //             Text($0)
                //         }
                //     }
                    
                //     Picker("Transcriber Language", selection: $selectedLanguage) {
                //         ForEach(languages, id: \.self) {
                //             Text($0)
                //         }
                //     }
                // }
                
                // Section(header: Text("Advanced Settings")) {
                //     HStack {
                //         Text("Silence Timeout")
                //         Spacer()
                //         Text("\(Int(silenceTimeout)) seconds")
                //             .font(.system(size: 16, weight: .regular, design: .rounded))
                //             .contentTransition(.numericText())
                //             .transaction { t in
                //                 t.animation = .default
                //         } 
                //     }
                //     Slider(value: $silenceTimeout, in: 30...300, step: 10)
                    
                //     HStack {
                //         Text("Max Call Duration")
                //         Spacer()
                //         Text("\(Int(maxCallDuration / 60)) minutes")
                //             .font(.system(size: 16, weight: .regular, design: .rounded))
                //             .contentTransition(.numericText())
                //             .transaction { t in
                //                 t.animation = .default
                //         } 
                //     }
                //     Slider(value: $maxCallDuration, in: 300...3600, step: 60)
                    
                //     HStack {
                //         Text("Words to Interrupt")
                //         Spacer()
                //         Text("\(Int(wordsToInterrupt))")
                //             .font(.system(size: 16, weight: .regular, design: .rounded))
                //             .contentTransition(.numericText())
                //             .transaction { t in
                //                 t.animation = .default
                //         } 
                //     }
                //     Slider(value: $wordsToInterrupt, in: 1...10, step: 1)
                // }

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

    private var membershipSection: some View {
        Section(header: Text("Membership")) {
            Button(action: {
                // Action for RES Pro (to be implemented)
            }) {
                HStack {
                    Text("RES Pro")
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                        .foregroundColor(.black)
                    Spacer()
                    Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                }
            Button(action: {
                    // Action for RES Pro (to be implemented)
                }) {
                    HStack {
                        Text("App Icon")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                        }
                    }
            }
    }
    
    private var subscriptionCard: some View {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top) {
                    Image("logo-res")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 40)
                        .zIndex(1)
                    Text("Pro")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.black.opacity(0.5))
                    }
                
                Text("Upgrade to RES Pro to enjoy unlimited calls with your contacts.")
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.957, green: 0.522, blue: 0),
                        Color(red: 0.961, green: 0.282, blue: 0)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
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
                        lineWidth: 1
                    )
                    .blendMode(.overlay)
                    .blur(radius: 1.0)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                Color.black.opacity(0.4),
                                Color.black.opacity(0),
                                Color.black.opacity(0.4)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 1
                    )
            )
            // .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)    
            // .padding(.vertical, 10)
        }
}
