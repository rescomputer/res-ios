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
            callManager.setupVapi()
            Task { await callManager.handleCallAction() }
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
                            Text(selectedPersona.systemPrompt)
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
            Button(action: {
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
            }) {
                Text(callEnded ? "start call" : "end call")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(callEnded ? Color.green : Color.red)
                    .cornerRadius(25)
                    .padding(.horizontal)
                    .padding(.vertical, 20)
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
