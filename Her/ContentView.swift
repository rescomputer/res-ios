import SwiftUI
import Vapi
import Combine

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
//            "model": [
//                "provider": "groq",
//                "model": "mixtral-8x7b-32768",
//                "messages": [
//                    ["role":"system", "content":"You are an assistant."]
//                ],
//            ],
//            "firstMessage": "Hey there",
//            "voice": "jennifer-playht"
            "model": [
                "provider": "openai",
                "model": "gpt-4",
                "messages": [
                    ["role":"system", "content":"You are an assistant."]
                ],
            ],
            "firstMessage": "Hello",
            "voice": "jennifer-playht"
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

//                Spacer()
                
                Text(callManager.callStateText)
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(.top, 30)

//                Text(callManager.callStateText)
//                    .font(.title)
//                    .fontWeight(.semibold)
//                    .foregroundColor(.white)
//                    .padding()
//                    .background(callManager.callStateColor)
//                    .cornerRadius(10)

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
