import SwiftUI
import Combine

struct SpeakingAvatar: View {
    let audioLevel: Float
    @Binding var callState: CallManagerNewDirection.CallState
    @Binding var conversationState: CallManagerNewDirection.ConversationState
    var personaImage: UIImage
    var showDebugInfo: Bool

    @State private var isAnimating = false
    @State private var lastUpdateTime: Date = Date()
    @State private var timeBetweenChanges: Double = 0.0

    var body: some View {
        let baseSize: CGFloat = 120
        let adjustedAudioLevel = min(audioLevel * 10, 1.0)
        let dynamicSize: CGFloat = baseSize + CGFloat(adjustedAudioLevel * 70)  // Dynamic size for the overlay
        let dynamicBlur: CGFloat = 5 + CGFloat(adjustedAudioLevel * 15)  // Dynamic blur radius

        ZStack {
            // remote audio level indicator
            if callState == .started && conversationState != .assistantThinking {
                Circle()
                    .stroke(.white, lineWidth: 12)
                    .frame(width: dynamicSize + 45, height: dynamicSize + 45)
                    .blur(radius: dynamicBlur)
                    .opacity(0.5)
                    .animation(.easeOut(duration: 0.4), value: adjustedAudioLevel)
            }

            Image(uiImage: personaImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: baseSize, height: baseSize)
                .clipShape(Circle())

            // useful for development
            if showDebugInfo {
                VStack {
                    Text(String(format: "Audio: %.2f", audioLevel * 10))
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(4)
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(8)
                    
                    Text(String(format: "Δt: %.0f ms", timeBetweenChanges))
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(4)
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(8)

                    Text(conversationState.rawValue)
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(4)
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(8)
                }
                .padding(.top, dynamicSize / 2 + 20)  // Adjusted for better placement
            }

            // loading spinner
            if callState == .loading || conversationState == .assistantThinking {
                Circle()
                    .trim(from: 0.25, to: 1)  // 3/4th circle
                    .stroke(LinearGradient(gradient: Gradient(colors: [.white, .white.opacity(0)]), startPoint: .leading, endPoint: .trailing), style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .opacity(0.5)
                    .frame(width: baseSize + 45, height: baseSize + 45)
                    .blur(radius: 3)
                    .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                    .onAppear {
                        withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                            isAnimating = true
                        }
                    }
                    .onDisappear {
                        isAnimating = false
                    }
            }
        }
        .frame(width: baseSize + 50, height: baseSize + 50)  // Overall size adjusted
        .onChange(of: audioLevel) { newValue in
            let currentTime = Date()
            timeBetweenChanges = currentTime.timeIntervalSince(lastUpdateTime) * 1000
            lastUpdateTime = currentTime
        }
    }
}

struct ContentView: View {
    @StateObject private var callManager = CallManagerNewDirection()
    @State private var audioLevel: Float = 0.0
    @State private var showDebugInfo: Bool = true
    @State private var isLoading: Bool = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()  // Setting the background to black

            VStack {
                VStack {
                    SpeakingAvatar(
                        audioLevel: audioLevel,
                        callState: .constant(isLoading ? .loading : .started),
                        conversationState: .constant(.assistantSpeaking),
                        personaImage: UIImage(imageLiteralResourceName: "chiller"),
                        showDebugInfo: showDebugInfo
                    )
                }
                .padding(.vertical, 32)
                
                Slider(value: $audioLevel, in: 0...0.1)
                    .padding()
                    .onChange(of: audioLevel) { newValue in
                        print("Slider value changed: \(newValue * 10)")
                    }
                
                Toggle("Show Audio Details", isOn: $showDebugInfo)
                    .foregroundColor(.white)
                    .padding()

                Toggle("Loading", isOn: $isLoading)
                    .foregroundColor(.white)
                    .padding()
            }
        }
    }
}

#Preview("Speaking Avatar Preview") {
    ContentView()
}
