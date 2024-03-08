import SwiftUI
import Vapi
import Combine
import AVKit

struct VideoPlayerView: UIViewRepresentable {
    var videoURL: URL
    
    func makeUIView(context: Context) -> UIView {
        let containerView = UIView(frame: .zero)
        
        // Initialize AVPlayer
        let player = AVPlayer(url: videoURL)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = containerView.bounds
        playerLayer.videoGravity = .resizeAspectFill
        containerView.layer.addSublayer(playerLayer)
        
        // Loop the video
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
            player.seek(to: .zero)
            player.play()
        }
        
        player.play() // Automatically play video
        
        return containerView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Update the view when needed
    }
}

class CallManager: ObservableObject {
    enum CallState {
        case started, loading, ended
    }

    @Published var callState: CallState = .ended
    var vapiEvents = [Vapi.Event]()
    private var cancellables = Set<AnyCancellable>()
    let vapi: Vapi

    init() {
        vapi = Vapi(
            publicKey: "a9a1bf8c-c389-490b-a82b-29fe9ba081d8"
        )
    }
    
    @Published var enteredText = ""

    func setupVapi() {
        vapi.eventPublisher
            .sink { [weak self] event in
                self?.vapiEvents.append(event)
                switch event {
                case .callDidStart:
                    self?.callState = .started
                case .callDidEnd:
                    self?.callState = .ended
                case .speechUpdate:
                    print(event)
                case .conversationUpdate:
                    print(event)
                case .functionCall:
                    print(event)
                case .hang:
                    print(event)
                case .metadata:
                    print(event)
                case .transcript:
                    print(event)
                case .error(let error):
                    print("Error: \(error)")
                }
            }
            .store(in: &cancellables)
        if let savedText = UserDefaults.standard.string(forKey: "enteredText"), !savedText.isEmpty {
                enteredText = savedText
            } else {
                enteredText = "A helpful assistant that gets to the point. Does not speak in bullet points. Answers clearly."
            }
    }
    
    func saveEnteredText() {
        UserDefaults.standard.set(enteredText, forKey: "enteredText")
    }
    

    @MainActor
    func handleCallAction() async {
        if callState == .ended {
            await startCall()
        } else {
            endCall()
        }
    }

    @MainActor
    func startCall() async {
        callState = .loading
        let assistant = [
            "model": [
                "provider": "openai",
                "model": "gpt-4",
                "messages": [
                    ["role":"system",
                     "content":enteredText]
//                     "content":"A helpful AI assistant. Gets to the point. Never responds with more than 10 sentences."]
                ],
            ],
            "firstMessage": "Hi",
            "voice": [
                "voiceId":"jennifer",
                "provider":"playht",
                "speed":1.3
            ],
            "transcriber": [
                "language": "en",
                "model": "nova-2-conversationalai",
                "provider": "deepgram"
            ]
            
        ] as [String : Any]
        do {
            try await vapi.start(assistant: assistant)
        } catch {
            print("Error starting call: \(error)")
            callState = .ended
        }
    }

    func endCall() {
        vapi.stop()
    }
}

struct ContentView: View {
    @StateObject private var callManager = CallManager()
    
    @State private var drawingHeight = true
    
       var animation: Animation {
           return .linear(duration: 0.5).repeatForever()
       }
    

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(gradient: Gradient(colors: [
                Color(red: 221/255, green: 102/255, blue: 58/255),
                Color(red: 221/255, green: 102/255, blue: 58/255)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                
                Spacer()

                Image(systemName: "waveform")
                    .font(.system(size: 112))
                    .foregroundColor(.white)
                    .opacity(0.9)

                Spacer()
                
                Text(callManager.callStateText)
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                
                ZStack(alignment: .leading) {
                    TextEditor(text: $callManager.enteredText)
                        .foregroundStyle(.secondary)
                        .cornerRadius(8)
                        .padding(.horizontal)
                        .onChange(of: callManager.enteredText) {
                            callManager.saveEnteredText()
                        }
                }
                
                Spacer()
                
                Button(action: {
                    Task {
                        await callManager.handleCallAction()
                    }
                }) {
                    Text(callManager.buttonText)
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.white.opacity(0.2))
                        .cornerRadius(10)
                }
                .disabled(callManager.callState == .loading)
                .padding(.horizontal, 40)

                Spacer()
            }
        }
        .onAppear {
            callManager.setupVapi()
        }
    }
    func bar(low: CGFloat = 0.0, high: CGFloat = 1.0) -> some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(.indigo.gradient)
            .frame(height: (drawingHeight ? high : low) * 64)
            .frame(height: 64, alignment: .bottom)
    }
}

extension CallManager {
    var callStateText: String {
        switch callState {
        case .started: return "Connected"
        case .loading: return "Connecting..."
        case .ended: return "Chat with an AI back-and-forth"
        }
    }

    var callStateColor: Color {
        switch callState {
        case .started: return .green.opacity(0.8)
        case .loading: return .orange.opacity(0.8)
        case .ended: return .gray.opacity(0.8)
        }
    }

    var buttonText: String {
        callState == .loading ? "Loading..." : (callState == .ended ? "Start Conversation" : "End Conversation")
    }

    var buttonColor: Color {
        callState == .loading ? .gray : (callState == .ended ? .green : .red)
    }
}
