import SwiftUI
import BottomSheet

struct SettingsView: View {
    @Binding var isActive: Bool
    
        var body: some View {
            NavigationView {
                VStack {
                    Text("Settings")
                        .font(.system(size: 24, weight: .regular, design: .rounded))
                        .foregroundColor(.black)
                        .padding()
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
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
                }
            }
            .accentColor(.black)
    }
}

struct CallScreen: View {
    @State private var selectedPersonaId: UUID?
    @State private var bottomSheetPosition: BottomSheetPosition = CallScreen.SHEET_POSITION_MIDDLE
    @State private var scrollOffset: CGFloat = 0
    @State private var isAtTop: Bool = true
    @State private var animationValue: Animation? = nil
    @State private var bioButtonText: String = "View Bio"
    @State private var additionalInfo: String = ""
    @State private var isInCall = false
    @State private var isSettingsActive = false

    @StateObject private var callManager = CallManagerNewDirection()
    @State private var settingsOffset: CGFloat = UIScreen.main.bounds.width
    private static let SHEET_POSITION_BOTTOM_FLOAT = CGFloat(100)
    private static let SHEET_POSITION_MIDDLE: BottomSheetPosition = .relative(0.31)
    private static let SHEET_POSITION_TOP: BottomSheetPosition = .relative(0.7)
    private static let SHEET_POSITION_FULL: BottomSheetPosition = .relative(1)
    private static let SHEET_POSITION_BOTTOM: BottomSheetPosition = .absolute(SHEET_POSITION_BOTTOM_FLOAT)
    
    init() {
        if let firstPersonaId = defaultPersonas.first?.id {
            _selectedPersonaId = State(initialValue: firstPersonaId)
        }
    }

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    screenContents()
                        .edgesIgnoringSafeArea(.top)
                        .bottomSheet(bottomSheetPosition: self.$bottomSheetPosition, switchablePositions: [
                            CallScreen.SHEET_POSITION_BOTTOM,
                            CallScreen.SHEET_POSITION_MIDDLE,
                            CallScreen.SHEET_POSITION_TOP
                        ], headerContent: {
                        }, mainContent: {
                            bottomSheetContents(geometry: geometry)
                        })
                        .customBackground(
                            Color.white.cornerRadius(15)
                        )
                        .enableContentDrag(true)
                        .dragIndicatorColor(.gray)
                        .customAnimation(animationValue)
                        .sheetWidth(.relative(1))
                }
            }
            .task {
                try? await Task.sleep(for: .seconds(0.25))
                animationValue = .spring(
                    response: 0.5,
                    dampingFraction: 0.75,
                    blendDuration: 1
                )
            }
            .onAppear {
                self.bottomSheetPosition = CallScreen.SHEET_POSITION_MIDDLE
                self.callManager.setupVapi()
            }
            .onChange(of: bottomSheetPosition) {
                updateBioButtonText()
            }
            .onChange(of: isSettingsActive) { newValue in
                if newValue {
                    self.bottomSheetPosition = CallScreen.SHEET_POSITION_FULL
                } else {
                    self.bottomSheetPosition = CallScreen.SHEET_POSITION_TOP
                }
            }
        }
    }

    @ViewBuilder
    private func screenContents() -> some View {
        if isInCall, let selectedPersona = selectedPersona {
            GeometryReader { geometry in
                ZStack {
                    Image(uiImage: selectedPersona.image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                        .blur(radius: 20)
                        .overlay(
                            Color.black.opacity(0.4)
                                .edgesIgnoringSafeArea(.all)
                        )

                    VStack {
                        Spacer().frame(height: geometry.safeAreaInsets.top + 212)
                        .padding(.horizontal)
                        
                        SpeakingAvatar(
                            audioLevel: callManager.remoteAudioLevel,
                            callState: $callManager.callState,
                            conversationState: $callManager.conversationState,
                            personaImage: selectedPersona.image,
                            showDebugInfo: false
                        )
                        Text(selectedPersona.name)
                            .font(.digital7(size: 28))
                            .foregroundColor(.white)
                            .padding(.bottom)
                        ConversationStateView(
                            callState: $callManager.callState,
                            conversationState: $callManager.conversationState,
                            personaName: selectedPersona.name
                        )
                        Spacer()
                        SpeakingUser(
                            audioLevel: callManager.localAudioLevel,
                            callState: $callManager.callState,
                            conversationState: $callManager.conversationState,
                            personaImage: selectedPersona.image,
                            showDebugInfo: false
                        ).padding(.bottom, CallScreen.SHEET_POSITION_BOTTOM_FLOAT)
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .top)
                }
            }
            .edgesIgnoringSafeArea(.all)
        } else {
            Color.black
                .frame(maxHeight: .infinity)
                .overlay(
                    VStack {
                        Spacer().frame(height: 150) // Adjust height as needed
                        if let selectedPersona = selectedPersona {
                            VStack {
                                Image(uiImage: selectedPersona.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 124, height: 124)
                                    .clipShape(Circle())
                                    .shadow(color: Color.white.opacity(0.45), radius: 10, x: 0, y: 0)
                                    .padding(.bottom, 16)
                                Text(selectedPersona.name)
                                    .font(.digital7(size: 28))
                                    .padding(.bottom, 12)
                                    .foregroundColor(.white)
                                Text(selectedPersona.description)
                                    .foregroundColor(.white)
                                Button(action: toggleBottomSheetPosition) {
                                    Text(bioButtonText)
                                        .fontWeight(.medium)
                                        .padding(.vertical, 12)
                                        .padding(.horizontal, 48)
                                        .background(Color.gray.opacity(0.3))
                                        .foregroundColor(.white)
                                        .cornerRadius(32)
                                }
                                .padding()
                                Text(additionalInfo)
                                    .foregroundColor(.white)
                                    .padding(.bottom, 8)
                                    .opacity(additionalInfoOpacity)
                                    .animation(.easeInOut, value: additionalInfoOpacity)
                            }
                            .padding(.bottom)
                        }
                        Spacer()
                    }
                )
        }
    }

@ViewBuilder
private func bottomSheetContents(geometry: GeometryProxy) -> some View {
    ZStack {
        VStack(spacing: 0) {
            HStack {
                if isInCall {
                    PrimaryButton(
                        title: "End Call",
                        type: .red,
                        action: endCall
                    )
                } else {
                    PrimaryButton(
                        title: "Call",
                        type: .orange,
                        action: startCall
                    )
                }
            }
            .padding(.horizontal)
            .padding(.top, 4)
            .padding(.bottom, 8)
            
            if !isInCall {
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("contacts")
                            .font(.system(size: 24, weight: .regular, design: .rounded))
                            .foregroundColor(Color(red: 0.224, green: 0.216, blue: 0.161))
                            .padding(.top, 6)
                            .padding(.leading, 15)
                        PadsView(personas: defaultPersonas, selectedPersonaId: $selectedPersonaId)
                        Text("options")
                            .font(.system(size: 24, weight: .regular, design: .rounded))
                            .foregroundColor(Color(red: 0.224, green: 0.216, blue: 0.161))
                            .padding(.bottom, 6)
                            .padding(.leading, 15)
                        CustomLinkView(
                            iconName: "gear",
                            title: "Settings",
                            action: {

                            },
                            navigateTo: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8, blendDuration: 0)) {
                                    isSettingsActive = true
                                    settingsOffset = 0
                                }
                             },
                            screenSize: geometry.size,
                            offset: geometry.frame(in: .global).minY,
                            minHeight: 100
                        )
                        .padding(.horizontal, 15)
                    }
                    .padding(.bottom, geometry.safeAreaInsets.bottom)
                }
            }
        }
        .opacity(isSettingsActive ? 0 : 1)

        SettingsView(isActive: $isSettingsActive)
            .offset(x: settingsOffset, y: 0)
            .onChange(of: isSettingsActive) { newValue in
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8, blendDuration: 0)) {
                    settingsOffset = newValue ? 0 : UIScreen.main.bounds.width
                }
            }
    }
}

    private var selectedPersona: Persona? {
        defaultPersonas.first(where: { $0.id == selectedPersonaId })
    }

    private func toggleBottomSheetPosition() {
        if bottomSheetPosition == CallScreen.SHEET_POSITION_MIDDLE {
            bottomSheetPosition = CallScreen.SHEET_POSITION_BOTTOM
        } else {
            bottomSheetPosition = CallScreen.SHEET_POSITION_MIDDLE
        }
    }

    private func updateBioButtonText() {
        if bottomSheetPosition == .absolute(100) {
            bioButtonText = "Hide Bio"
            additionalInfo = "Additional info here"
        } else {
            bioButtonText = "View Bio"
            additionalInfo = ""
        }
    }

    private var additionalInfoOpacity: Double {
        bottomSheetPosition == CallScreen.SHEET_POSITION_BOTTOM ? 1.0 : 0.0
    }

    private func startCall() {
        isInCall = true
        if let selectedPersona = selectedPersona {
            callManager.selectedPersona = selectedPersona
            bottomSheetPosition = CallScreen.SHEET_POSITION_BOTTOM

            Task {
                await callManager.initializeVapiAndStartCall()
            }
        }
    }

    private func endCall() {
        isInCall = false
        isSettingsActive = false
        Task {
            await callManager.endCall()
            bottomSheetPosition = CallScreen.SHEET_POSITION_MIDDLE
        }
    }
}

#Preview("Call Screen") {
    CallScreen()
}
