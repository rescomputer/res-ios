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

                        renderButtons()
                            .padding(.horizontal)
                            .padding(.top)
                            .background(Color.white)

                        PadsView(personas: defaultPersonas, selectedPersonaId: $selectedPersonaId)
                            .padding(.bottom, geometry.safeAreaInsets.bottom)
                    }
                    .edgesIgnoringSafeArea(.all)
                }
            }
        }
        .tint(Color.white)
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
                                .shadow(color: Color.white.opacity(0.45), radius: 10, x: 0, y: 0)  // Adds a white glow
                                .padding(.bottom, 16)
                            Text(selectedPersona.name)
                                .font(.digital7(size: 28))
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
    
    /*
     Once the data model is fleshed out a bit more, we can make this less hacky.
     Currently it's iterating through the array to find the right id.
     And in other cases, we're just passing the id down instead of the whole persona
     */
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
