//import SwiftUI
//import Vapi
//import Combine
//
//class CallManager: ObservableObject {
//    enum CallState {
//        case started, loading, ended
//    }
//
//    @Published var callState: CallState = .ended
//    var vapiEvents = [Vapi.Event]()
//    private var cancellables = Set<AnyCancellable>()
//    let vapi: Vapi
//
//    init() {
//        vapi = Vapi(
//            publicKey: "a9a1bf8c-c389-490b-a82b-29fe9ba081d8"
//        )
//    }
//
//    func setupVapi() {
//        vapi.eventPublisher
//            .sink { [weak self] event in
//                self?.vapiEvents.append(event)
//                switch event {
//                case .callDidStart:
//                    self?.callState = .started
//                case .callDidEnd:
//                    self?.callState = .ended
//                case .speechUpdate:
//                    print(event)
//                case .conversationUpdate:
//                    print(event)
//                case .functionCall:
//                    print(event)
//                case .hang:
//                    print(event)
//                case .metadata:
//                    print(event)
//                case .transcript:
//                    print(event)
//                case .error(let error):
//                    print("Error: \(error)")
//                }
//            }
//            .store(in: &cancellables)
//    }
//
//    @MainActor
//    func handleCallAction() async {
//        if callState == .ended {
//            await startCall()
//        } else {
//            endCall()
//        }
//    }
//
//    @MainActor
//    func startCall() async {
//        callState = .loading
//        let assistant = [
//            "model": [
//                "provider": "openai",
//                "model": "gpt-3.5-turbo",
//                "messages": [
//                    ["role":"system", "content":"You are an assistant."]
//                ],
//            ],
//            "firstMessage": "Hey there",
//            "voice": "jennifer-playht"
//        ] as [String : Any]
//        do {
//            try await vapi.start(assistant: assistant)
//        } catch {
//            print("Error starting call: \(error)")
//            callState = .ended
//        }
//    }
//
//    func endCall() {
//        vapi.stop()
//    }
//}
//
//struct ContentView: View {
//    @StateObject private var callManager = CallManager()
//
//    var body: some View {
//        ZStack {
//            // Background gradient
//            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.purple.opacity(0.7)]), startPoint: .top, endPoint: .bottom)
//                .edgesIgnoringSafeArea(.all)
//
//            VStack(spacing: 20) {
//                Text("Vapi Call Interface")
//                    .font(.largeTitle)
//                    .fontWeight(.bold)
//                    .foregroundColor(.white)
//
//                Spacer()
//
//                Text(callManager.callStateText)
//                    .font(.title)
//                    .fontWeight(.semibold)
//                    .foregroundColor(.white)
//                    .padding()
//                    .background(callManager.callStateColor)
//                    .cornerRadius(10)
//
//                Spacer()
//
//                Button(action: {
//                    Task {
//                        await callManager.handleCallAction()
//                    }
//                }) {
//                    Text(callManager.buttonText)
//                        .font(.title2)
//                        .fontWeight(.bold)
//                        .foregroundColor(.white)
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                        .background(callManager.buttonColor)
//                        .cornerRadius(10)
//                }
//                .disabled(callManager.callState == .loading)
//                .padding(.horizontal, 40)
//
//                Spacer()
//            }
//        }
//        .onAppear {
//            callManager.setupVapi()
//        }
//    }
//}
//
//extension CallManager {
//    var callStateText: String {
//        switch callState {
//        case .started: return "Call in Progress"
//        case .loading: return "Connecting..."
//        case .ended: return "Call Off"
//        }
//    }
//
//    var callStateColor: Color {
//        switch callState {
//        case .started: return .green.opacity(0.8)
//        case .loading: return .orange.opacity(0.8)
//        case .ended: return .gray.opacity(0.8)
//        }
//    }
//
//    var buttonText: String {
//        callState == .loading ? "Loading..." : (callState == .ended ? "Start Call" : "End Call")
//    }
//
//    var buttonColor: Color {
//        callState == .loading ? .gray : (callState == .ended ? .green : .red)
//    }
//}
