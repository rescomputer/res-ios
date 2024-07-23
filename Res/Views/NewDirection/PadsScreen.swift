import SwiftUI

struct PadsScreen: View {
    @State private var selectedPersonaId: UUID?
    @State private var showCallScreen = false
    @State private var showAlert = false
    
    init() {
        if let firstPersonaId = defaultPersonas.first?.id {
            _selectedPersonaId = State(initialValue: firstPersonaId)
        }
    }

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    VStack(spacing: 0) {
                        screenContents()

                        HStack {
//                            renderButtons()
                            CallButtonn(title: "call", isRedBackground: false, action: {
                                showCallScreen = true
                            })
                        }
                        .padding(.horizontal)
                        .padding(.top)
                        .background(Color.white)

                        PadsView(personas: defaultPersonas, selectedPersonaId: $selectedPersonaId)
                            .padding(.bottom, geometry.safeAreaInsets.bottom)
                    }
                    .edgesIgnoringSafeArea(.all)
                }
            }
            .tint(Color.white)
            .navigationDestination(isPresented: $showCallScreen) {
                selectedPersonaView()
            }
        }
    }

    @ViewBuilder
    private func renderButtons() -> some View {
        HStack(spacing: 20) {
            Button(action: {
                self.showAlert = true
            }) {
                Text("Message")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .padding(.all, 12)
                    .frame(maxWidth: .infinity)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
            }

            NavigationLink(destination: selectedPersonaView()) {
                Text("Call")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .padding(.all, 12)
                    .frame(maxWidth: .infinity)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
            }
        }
    }

    @ViewBuilder
    private func screenContents() -> some View {
        Color.black
            .frame(maxHeight: .infinity)
            .overlay(
                VStack {
                    if let selectedPersonaId = selectedPersonaId, let selectedPersona = defaultPersonas.first(where: { $0.id == selectedPersonaId }) {
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
                        }
                        .padding(.bottom)
                    }
                }
            )
    }

    private func selectedPersonaView() -> some View {
        if let selectedPersonaId = selectedPersonaId, let selectedPersona = defaultPersonas.first(where: { $0.id == selectedPersonaId }) {
            return AnyView(CallScreen(selectedPersona: selectedPersona))
        } else {
            return AnyView(EmptyView())
        }
    }
}

#Preview("Pads Screen") {
    PadsScreen()
}




struct CallButtonn: View {
    var title: String
    var isRedBackground: Bool = false
    var action: () -> Void // Add this line

    var body: some View {
        Button(action: {
            action() // Call the custom action
        }) {
            Text(title)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.white)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(
                    Group {
                        if isRedBackground {
                            LinearGradient(gradient: Gradient(colors: [Color(red: 1.0, green: 0.4, blue: 0.4), Color(red: 0.9, green: 0.0, blue: 0.0)]), startPoint: .top, endPoint: .bottom)
                                .cornerRadius(40)
                                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 40)
                                        .stroke(Color(red: 0.8, green: 0.0, blue: 0.0), lineWidth: 1)
                                )
                        } else {
                            LinearGradient(gradient: Gradient(colors: [Color.orange, Color.red]), startPoint: .top, endPoint: .bottom)
                                .cornerRadius(40)
                                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 40)
                                        .stroke(Color(red: 0.8, green: 0.4, blue: 0.0), lineWidth: 1)
                                )
                        }
                    }
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 40)
                        .stroke(Color.black.opacity(0.2), lineWidth: 1)
                        .blur(radius: 1)
                        .offset(x: 0, y: 1)
                        .mask(RoundedRectangle(cornerRadius: 40).fill(LinearGradient(gradient: Gradient(colors: [Color.black, Color.clear]), startPoint: .top, endPoint: .bottom)))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 40)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        .blur(radius: 1)
                        .offset(x: 0, y: -1)
                        .mask(RoundedRectangle(cornerRadius: 40).fill(LinearGradient(gradient: Gradient(colors: [Color.clear, Color.white]), startPoint: .top, endPoint: .bottom)))
                )
        }
    }
}

struct CallButtonn_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CallButtonn(title: "call", isRedBackground: false, action: { print("Call action") })
            CallButtonn(title: "end call", isRedBackground: true, action: { print("End call action") })
        }
    }
}

