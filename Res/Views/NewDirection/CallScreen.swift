import SwiftUI
import UIKit

struct CallScreen: View {
    var selectedPersona: Persona

    @StateObject private var callManager = CallManagerNewDirection()
    @Environment(\.presentationMode) var presentationMode

    @State private var callEnded = false

    var body: some View {
        VStack(spacing: 0) {
            screenContents()
                .frame(maxHeight: .infinity)

            actionButtons()
                .frame(height: 256)  // Set the height to the typical keyboard height
                .padding(.horizontal)
                .padding(.bottom, 30)
                .background(Color.white)
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            callManager.selectedPersonaSystemPrompt = selectedPersona.systemPrompt // Set the system prompt
            callManager.selectedPersonaVoice = selectedPersona.voice // Set the voice configuration
            Task { await callManager.initializeVapiAndStartCall() }
        }
    }

    @ViewBuilder
    private func screenContents() -> some View {
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
                    // Adding padding to account for the status bar and navigation bar
                    Spacer().frame(height: geometry.safeAreaInsets.top + 112) // Adjust the height if needed
                    
                    HStack(alignment: .top) {
                        Image(uiImage: selectedPersona.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 58, height: 58)
                            .clipShape(Circle())

                        VStack(alignment: .leading) {
                            Text(selectedPersona.name)
                                .foregroundColor(.white)
                            Text(selectedPersona.description)
                                .foregroundColor(.gray)
                                .font(.system(size: 16))
                        }
                        .padding(.leading, 8)

                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    Spacer() // Spacer at the bottom to push the content to the top
                }
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .top) // Ensure the VStack takes the full height and aligns content to the top
            }
        }
        .edgesIgnoringSafeArea(.all) // Ensure the background image covers the entire screen
    }

    @ViewBuilder
    private func actionButtons() -> some View {
        VStack {
            CallButton(callEnded: callEnded) {
                            Task {
                                if callEnded {
                                    await callManager.handleStartCall()
                                    callEnded = false
                                } else {
                                    await callManager.endCall() // End the call
                                    callEnded = true
                                    self.presentationMode.wrappedValue.dismiss() // Navigate back
                                }
                            }
                            let impactMed = UIImpactFeedbackGenerator(style: .soft)
                            impactMed.impactOccurred()
                        }

            HStack {
                Button(action: {
                    print("Select tapped")
                }) {
                    Text("select")
                        .foregroundColor(.black)
                        .padding(.horizontal)
                        .background(Color.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                Button(action: {
                    print("Settings tapped")
                }) {
                    Text("settings")
                        .foregroundColor(.black)
                        .padding(.horizontal)
                        .background(Color.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 30)
        }
    }
}

#Preview("Call Screen") {
    CallScreen(selectedPersona: defaultPersonas.first!)
}


struct CallButton: View {
    var callEnded: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(callEnded ? "start call" : "end call")
                .foregroundColor(.white)
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: callEnded ? [Color(hex: "EE8243"), Color(hex: "DE5731")] : [Color.red.opacity(0.8), Color.red.opacity(0.6)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color(hex: "666666"), lineWidth: 1)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color.white.opacity(0.5), lineWidth: 1)
                                        .blur(radius: 1)
                                        .offset(x: -1, y: -1)
                                        .mask(
                                            RoundedRectangle(cornerRadius: 25)
                                                .fill(LinearGradient(
                                                    gradient: Gradient(colors: [Color.clear, Color.white]),
                                                    startPoint: .bottomTrailing,
                                                    endPoint: .topLeading
                                                ))
                                        )
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
                        .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 3)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                )
                .cornerRadius(25)
                .padding(.horizontal)
                .padding(.vertical, 20)
        }
    }
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
