import SwiftUI
import Combine

struct SpeakingUser: View {
    let audioLevel: Float
    @Binding var callState: CallManagerNewDirection.CallState
    @Binding var conversationState: CallManagerNewDirection.ConversationState
    var personaImage: UIImage
    var showDebugInfo: Bool

    @State private var isAnimating = false
    @State private var lastUpdateTime: Date = Date()
    @State private var timeBetweenChanges: Double = 0.0

    var body: some View {
        let baseSize: CGFloat = 160
        let adjustedAudioLevel = min(audioLevel * 10, 1.0)
        let blurRadius: CGFloat = 5  // Constant blur radius
        let semiCircleHeight: CGFloat = baseSize + 80  // Adjust as needed for semi-circle height

        ZStack {
            if callState == .started && (
                conversationState == .userSpeaking || conversationState == .assistantThinking
                ) {
                // Largest semi-circle
                HalfCircle()
                    .stroke(Color.white, lineWidth: 16)
                    .frame(width: baseSize + 80, height: baseSize + 80)
                    .blur(radius: blurRadius)
                    .opacity(Double(min(-0.1 + adjustedAudioLevel * 0.7, 0.5)))
                    .animation(.easeOut(duration: 0.75), value: adjustedAudioLevel)
                
                // Middle semi-circle
                HalfCircle()
                    .stroke(Color.white, lineWidth: 16)
                    .frame(width: baseSize, height: baseSize)
                    .blur(radius: blurRadius)
                    .opacity(Double(min(0 + adjustedAudioLevel * 0.7, 0.5)))
                    .animation(.easeOut(duration: 1.5), value: adjustedAudioLevel)
                
                // Smallest semi-circle
                HalfCircle()
                    .stroke(Color.white, lineWidth: 16)
                    .frame(width: baseSize - 80, height: baseSize - 80)
                    .blur(radius: blurRadius)
                    .opacity(Double(0.2 + adjustedAudioLevel * 0.5))
                    .animation(.easeOut(duration: 2.25), value: adjustedAudioLevel)
            }

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
                .padding(.top, baseSize / 2 + 20)  // Adjusted for better placement
            }
        }
        .frame(width: baseSize + 100, height: semiCircleHeight / 2 + 20)  // Set height to match the semi-circle
        .onChange(of: audioLevel) { newValue in
            let currentTime = Date()
            timeBetweenChanges = currentTime.timeIntervalSince(lastUpdateTime) * 1000
            lastUpdateTime = currentTime
        }
    }
}

struct HalfCircle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY),
                    radius: rect.width / 2,
                    startAngle: .degrees(180),
                    endAngle: .degrees(0),
                    clockwise: false)
        return path
    }
}

struct SpeakingUserPreview: View {
    @StateObject private var callManager = CallManagerNewDirection()
    @State private var audioLevel: Float = 0.0
    @State private var showDebugInfo: Bool = true
    @State private var isLoading: Bool = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()  // Setting the background to black

            VStack {
                VStack {
                    SpeakingUser(
                        audioLevel: audioLevel,
                        callState: .constant(isLoading ? .loading : .started),
                        conversationState: .constant(.userSpeaking),
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

#Preview("Speaking User Preview") {
    SpeakingUserPreview()
}
