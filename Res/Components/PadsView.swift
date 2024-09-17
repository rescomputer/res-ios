import SwiftUI

struct PadsView: View {
    @EnvironmentObject var personaData: PersonaData
    @Binding var selectedPersonaId: UUID?
    
    let spacing: CGFloat = 14
    let rows: Int = 3
    let columns: Int = 3

    var body: some View {
        VStack(spacing: spacing) {
            ForEach(0..<rows, id: \.self) { row in
                HStack(spacing: spacing) {
                    ForEach(0..<columns, id: \.self) { column in
                        let index = row * columns + column
                        if index < personaData.defaultPersonas.count {
                            let persona = personaData.defaultPersonas[index]
                            PadButton(selectedPersonaId: $selectedPersonaId, persona: persona)
                        } else {
                            BlankPad()
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 15)
        .padding(.bottom, 20)
    }
}

struct BlankPad: View {
    var body: some View {
        PadButton.defaultPadBackground
            .aspectRatio(7/4, contentMode: .fit)  // Ensure the aspect ratio matches the persona pads
    }
}

struct PadButton: View {
    @Binding var selectedPersonaId: UUID?
    var persona: Persona
    @State private var isTouched = false // Track touch state

    var body: some View {
        ZStack(alignment: .topLeading) {
            padBackground
            textView
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .aspectRatio(7/4, contentMode: .fit)  // Enforces aspect ratio strictly
        .contentShape(Rectangle()) // Makes the entire ZStack tappable
        .onTapGesture {
            self.selectedPersonaId = persona.id
        }
        .onLongPressGesture(minimumDuration: 0.05, pressing: { isPressing in
            self.isTouched = isPressing
        }, perform: {})
    }

    private var padBackground: some View {
        Group {
            if selectedPersonaId == persona.id {
                activePadBackground
            } else if isTouched {
                touchedPadBackground
            } else {
                Self.defaultPadBackground
            }
        }
    }

    private var textView: some View {
        VStack(alignment: .leading) {
            Text(persona.name)
                .font(.caption)
                .truncationMode(.tail)
                .padding(.horizontal, 8)
                .foregroundColor(
                    Color(
                        hex: selectedPersonaId == persona.id
                        ? "993A18"
                        : "777777"
                    )
                )
        }
        .padding(.top, 12)
    }

    private var activePadBackground: some View {
        RoundedRectangle(cornerRadius: 15)
            .stroke(Color(hex: "704518"), lineWidth: 1)
            .fill(
                RadialGradient(
                    gradient: Gradient(colors: [Color(hex: "EE7D48"), Color(hex: "F7CD8B")]),
                    center: .center,
                    startRadius: 10,
                    endRadius: 70
                )
            )
            .overlay(
                // Inner light stroke
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.3),
                                Color.white.opacity(0),
                                Color(hex: "EE7D48").opacity(0.5)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 2
                    )
                    .blendMode(.overlay)
            )
            .shadow(color: Color(hex: "EE7D48").opacity(0.8), radius: 5, x: 0, y: 0)
            .shadow(color: Color(hex: "EE7D48").opacity(0.3), radius: 5, x: 0, y: 5)
    }

    private var touchedPadBackground: some View {
        RoundedRectangle(cornerRadius: 15)
            .stroke(Color(hex: "666666"), lineWidth: 1)
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [Color(red: 0.906, green: 0.906, blue: 0.867), Color(red: 0.863, green: 0.863, blue: 0.816)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.gray.opacity(0.7), lineWidth: 2)
                    .blur(radius: 6)
                    .offset(x: 6, y: 6)
                    .mask(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.7)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.white.opacity(0.9), lineWidth: 2)
                    .blur(radius: 6)
                    .offset(x: -6, y: -6)
                    .mask(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [Color.black.opacity(0.7), Color.clear]),
                                startPoint: .bottomTrailing,
                                endPoint: .topLeading
                            ))
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.black.opacity(0.25), lineWidth: 10)
                    .blur(radius: 10)
                    .mask(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.5)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .padding(4)
                    )
            )
    }

    static var defaultPadBackground: some View {
        RoundedRectangle(cornerRadius: 15)
            .stroke(Color(hex: "666666"), lineWidth: 1)
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.973, green: 0.973, blue: 0.949),
                        Color(red: 0.953, green: 0.953, blue: 0.914)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 3)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.white.opacity(1), lineWidth: 2)
                    .blur(radius: 1)
                    .offset(x: -1, y: -1)
                    .mask(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [Color.clear, Color.white]),
                                startPoint: .bottomTrailing,
                                endPoint: .topLeading
                            ))
                    )
            )
    }
}

struct PadsView_Previews: PreviewProvider {
    @State static var selectedPersonaId: UUID? = DefaultPersonas.getDefaultPersonas().first?.id

    static var previews: some View {
        PadsView(selectedPersonaId: $selectedPersonaId)
            .environmentObject(PersonaData())
    }
}