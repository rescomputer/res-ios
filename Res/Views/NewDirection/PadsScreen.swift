import SwiftUI
import BottomSheet

struct PadsScreen: View {
    @State private var selectedPersonaId: UUID?
    @State private var showCallScreen = false
    @State private var bottomSheetPosition: BottomSheetPosition = .relative(0.4)
    @State private var scrollOffset: CGFloat = 0
    @State private var isAtTop: Bool = true
    @State private var animationValue: Animation? = nil
    @State private var bioButtonText: String = "View Bio"
    @State private var additionalInfo: String = ""

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
                            .absolute(100),
                            .relative(0.4),
                            .relative(0.7)
                        ], headerContent: {
                        }, mainContent: {
                            bottomSheetContents(geometry: geometry)
                        })
                        .customBackground(
                            Color.white
                                .shadow(color: .white, radius: 0, x: 0, y: 0)
                        )
                        .enableContentDrag(true)
                        .customAnimation(animationValue)
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
                self.bottomSheetPosition = .relative(0.4)
            }
            .onChange(of: bottomSheetPosition) { newPosition in
                updateBioButtonText()
            }
            .navigationDestination(isPresented: $showCallScreen) {
                selectedPersonaView()
            }
        }
    }

    @ViewBuilder
    private func screenContents() -> some View {
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
                                .frame(width: 140, height: 140)
                                .clipShape(Circle())
                                .shadow(color: Color.white.opacity(0.45), radius: 10, x: 0, y: 0)
                                .padding(.bottom, 16)
                            Text(selectedPersona.name)
                                .font(.system(size: 28))
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

    @ViewBuilder
    private func bottomSheetContents(geometry: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            HStack {
                PrimaryButton(
                    title: "Call",
                    type: .orange,
                    action: { showCallScreen = true }
                )
            }
            .padding(.horizontal)
            .padding(.vertical)
            
            ScrollView {
                GeometryReader { proxy in
                    Color.clear
                        .preference(key: ScrollOffsetPreferenceKey.self, value: proxy.frame(in: .named("scroll")).minY)
                }
                .frame(height: 0)

                PadsView(personas: defaultPersonas, selectedPersonaId: $selectedPersonaId)
                    .padding(.bottom, geometry.safeAreaInsets.bottom)
            }
            .coordinateSpace(name: "scroll")
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                if value == 0 && !isAtTop {
                    bottomSheetPosition = .relative(0.4)
                    isAtTop = true
                } else if value != 0 && isAtTop {
                    isAtTop = false
                }
            }
        }
    }

    private var selectedPersona: Persona? {
        defaultPersonas.first(where: { $0.id == selectedPersonaId })
    }

    private func selectedPersonaView() -> some View {
        if let selectedPersona = selectedPersona {
            return AnyView(CallScreen(selectedPersona: selectedPersona))
        } else {
            return AnyView(EmptyView())
        }
    }

    private func toggleBottomSheetPosition() {
        if bottomSheetPosition == .relative(0.4) {
            bottomSheetPosition = .absolute(100)
        } else {
            bottomSheetPosition = .relative(0.4)
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
        bottomSheetPosition == .absolute(100) ? 1.0 : 0.0
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview("Pads Screen") {
    PadsScreen()
}
