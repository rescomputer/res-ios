//
//  SettingsView.swift
//  Res
//
//  Created by Steven Sarmiento on 9/15/24.
//

import MessageUI
import SwiftUI

struct SettingsView: View {
    @Binding var isActive: Bool
    @Environment(\.openURL) var openURL

    @ObservedObject var callManager: CallManagerNewDirection

    @State private var isSubscribed: Bool = true
    @State private var showPaywallSheet = false

    // @State private var selectedVoiceProvider = "default"
    // @State private var selectedAIModel = "gpt-4o"
    // @State private var selectedLanguage = "en"
    // @State private var silenceTimeout = 120.0
    // @State private var maxCallDuration = 1800.0
    // @State private var wordsToInterrupt = 1.0
    @State private var voiceSpeed = 1.0
    @State private var buildNumber: String =
        Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "Unknown"

    @State private var isManageSubscriptionActive = false
    @State private var isAppIconSelectionActive = false
    @State private var subscriptionOffset: CGFloat = UIScreen.main.bounds.width
    @State private var appIconOffset: CGFloat = UIScreen.main.bounds.width
    @State private var isFeedbackFlowActive = false
    @State private var feedbackOffset: CGFloat = UIScreen.main.bounds.width

    @State private var isShowingMailView = false
    @State private var mailResult: Result<MFMailComposeResult, Error>?

    // let voiceProviders = ["default", "elevenlabs", "azure"]
    // let aiModels = ["gpt-4o", "gpt-4-0125-preview", "gpt-4-1106-preview"]
    // let languages = ["en", "es", "fr", "de"]
    var body: some View {
        ZStack {
            mainSettingsView
                .opacity(isManageSubscriptionActive || isAppIconSelectionActive ? 0 : 1)

            ManageSubscriptionView(isActive: $isManageSubscriptionActive)
                .offset(x: subscriptionOffset, y: 0)

            AppIconView(isActive: $isAppIconSelectionActive)
                .offset(x: appIconOffset, y: 0)

            // FeedbackFlow(isPresented: $isFeedbackFlowActive)
            //     .offset(x: feedbackOffset, y: 0)
        }
        .accentColor(.orange)
        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        .onChange(of: isManageSubscriptionActive) { newValue in
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8, blendDuration: 0)) {
                subscriptionOffset = newValue ? 0 : UIScreen.main.bounds.width
            }
        }
        .onChange(of: isAppIconSelectionActive) { newValue in
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8, blendDuration: 0)) {
                appIconOffset = newValue ? 0 : UIScreen.main.bounds.width
            }
        }
        // .onChange(of: isFeedbackFlowActive) { newValue in
        //     withAnimation(.spring(response: 0.3, dampingFraction: 0.8, blendDuration: 0)) {
        //         feedbackOffset = newValue ? 0 : UIScreen.main.bounds.width
        //     }
        // }
    }

    private var mainSettingsView: some View {

        VStack(spacing: 0) {
            // Custom navigation bar
            HStack {
                Button(action: {
                    isActive = false
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        // Text("RES")
                    }
                    .foregroundColor(.orange)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                }
                Spacer()
                Text("Settings")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(Color(red: 0.271, green: 0.267, blue: 0.2))
                Spacer()
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8, blendDuration: 0)) {
                        isShowingMailView = true
                    }
                }) {
                    HStack {
                        Image(systemName: "questionmark.bubble")
                        // Text("RES")
                    }
                    .foregroundColor(.orange)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                }
            }
            .padding()
            .background(Color(red: 0.945, green: 0.945, blue: 0.918))
            Form {
                if isSubscribed {
                    membershipSection
                } else {
                    subscriptionCard
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                }

                Section(
                    header: HStack {
                        Text("Voice Speed")
                        Spacer()
                        Text(String(format: "%.1fx", voiceSpeed))
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                            .contentTransition(.numericText())
                            .transaction { t in
                                t.animation = .default
                            }
                    }
                ) {
                    HStack {
                        Image(systemName: "tortoise.fill")
                            .foregroundColor(.black.opacity(0.3))
                        Slider(value: $callManager.voiceSpeed, in: 0.5...2.0, step: 0.1) {
                            changing in
                            if !changing {
                                let generator = UIImpactFeedbackGenerator(style: .medium)
                                generator.impactOccurred()
                                UserDefaults.standard.set(
                                    callManager.voiceSpeed, forKey: "voiceSpeed")
                            }
                        }
                        Image(systemName: "hare.fill")
                            .foregroundColor(.black.opacity(0.3))
                    }
                }

                Section(header: Text("Privacy")) {
                    Toggle("Privacy Mode", isOn: $callManager.hipaaEnabled)
                        .tint(.orange)

                }

                Section(header: Text("Community")) {

                    Button(action: {
                        if let url = URL(string: "https://x.com/res_computer") {
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
                        if let url = URL(string: "https://discord.gg/Fjf2mRkqsV") {
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
                        if let url = URL(string: "https://res.computer/privacy-policy") {
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
                        if let url = URL(
                            string:
                                "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")
                        {
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
        }
    }

    private var membershipSection: some View {
        Section(header: Text("RES Pro")) {
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8, blendDuration: 0)) {
                    isManageSubscriptionActive = true
                    subscriptionOffset = 0
                }
            }) {
                HStack {
                    Text("Manage Subscription")
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                        .foregroundColor(.black)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
            }
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8, blendDuration: 0)) {
                    isAppIconSelectionActive = true
                    appIconOffset = 0
                }
            }) {
                HStack {
                    Text("App Icon")
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                        .foregroundColor(.black)
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
                    .frame(width: 80, height: 35)
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
                    Color(red: 0.961, green: 0.282, blue: 0),
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
                            Color.black.opacity(0.5),
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
                            Color.black.opacity(0.4),
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 1
                )
        )
        .onTapGesture {
            showPaywallSheet = true
        }
        .sheet(isPresented: $showPaywallSheet) {
            PaywallScrollView(
                dismissAction: { showPaywallSheet = false },
                onSuccessfulPurchase: {
                    // Handle successful purchase here
                    showPaywallSheet = false
                }
            )
            .paywallFooter()
            //.environmentObject(userViewModel) // Make sure to pass the userViewModel
        }
        .sheet(isPresented: $isShowingMailView) {
            MailView(
                isShowing: $isShowingMailView, result: $mailResult,
                subject: "RES Feedback",
                messageBody: "I'd like to report a bug or suggest a feature.",
                toRecipients: ["support@artificialtechnologycorp.com"])
        }
    }
}

struct MailView: UIViewControllerRepresentable {
    @Binding var isShowing: Bool
    @Binding var result: Result<MFMailComposeResult, Error>?

    let subject: String
    let messageBody: String
    let toRecipients: [String]

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding var isShowing: Bool
        @Binding var result: Result<MFMailComposeResult, Error>?

        init(isShowing: Binding<Bool>, result: Binding<Result<MFMailComposeResult, Error>?>) {
            _isShowing = isShowing
            _result = result
        }

        func mailComposeController(
            _ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult,
            error: Error?
        ) {
            defer {
                isShowing = false
            }
            if let error = error {
                self.result = .failure(error)
            } else {
                self.result = .success(result)
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(isShowing: $isShowing, result: $result)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>)
        -> MFMailComposeViewController
    {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setSubject(subject)
        vc.setMessageBody(messageBody, isHTML: false)
        vc.setToRecipients(toRecipients)

        // Set the modal presentation style to full screen
        vc.modalPresentationStyle = .fullScreen

        return vc
    }

    func updateUIViewController(
        _ uiViewController: MFMailComposeViewController,
        context: UIViewControllerRepresentableContext<MailView>
    ) {}
}
