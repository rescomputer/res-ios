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

    @Published var speed: Double = 1.0 {
        didSet {
            UserDefaults.standard.set(speed, forKey: "speed")
        }
    }

    @Published var voice: String = "alloy" { //TODO fix
        didSet {
            UserDefaults.standard.set(voice, forKey: "voice")
        }
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
        if let savedText = UserDefaults.standard.string(forKey: "enteredText"), !savedText.isEmpty {
                enteredText = savedText
            } else {
                enteredText = "A helpful assistant that gets to the point. Does not speak in bullet points. Answers clearly."
            }
        if let savedSpeed = UserDefaults.standard.object(forKey: "speed") as? Double {
            speed = savedSpeed
        }
        if let savedVoice = UserDefaults.standard.string(forKey: "voice") {
            voice = savedVoice
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
                ],
                "maxTokens": 1000
            ],
            "firstMessage": "Hello",
            "voice": [
                "voiceId": voice,
                "provider":"openai",
                "speed":speed
            ],
            "transcriber": [
                "language": "en",
                "model": "nova-2",
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
    
    @FocusState private var isTextFieldFocused: Bool
    
    var animation: Animation {
        return .linear(duration: 0.5).repeatForever()
    }
    
    var body: some View {
        
        ScrollView {    // Background gradient
            VStack(alignment: .center, spacing: 20) {
                Spacer()
                HStack {
                    Spacer()
                    Text("Have a back-and-forth conversation")
                        .font(.system(.title3, design: .default))
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                }
                
                
                HStack {
                    Spacer()
                    Text("When you talk, it will listen")
                        .font(.system(.callout, design: .default))
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                }
                
                Spacer()
                
                HStack {
                    Text("Custom Instructions")
                        .multilineTextAlignment(.leading)
                        .foregroundColor(Color(hue: 0, saturation: 0, brightness: 0.134, opacity: 1))
                    
                    Spacer()
                    //                    Image(systemName: "list.bullet")
                    //                        .foregroundColor(Color.blue)
                    
                    //                    Text("Examples")
                    //                        .multilineTextAlignment(.leading)
                    //                        .foregroundColor(Color.blue)
                    //                        .font(.system(.footnote, design: .default))
                }
                .padding(.horizontal)
                
                HStack {
                    CustomTextEditor(text: $callManager.enteredText)
                        .font(.system(.callout, design: .default))
                        .background(Color(UIColor.white))
                        .frame(minHeight: 120)
//                        .padding(3)
                    //                            .border(Color.gray, width: 1)
                        .cornerRadius(10)
                        
                    //                        .lin
                    //                    TextField("Custom Instructions", text: $callManager.enteredText, axis: .vertical)
                    //                        .textFieldStyle(.roundedBorder)
                    //                        .lineLimit(8)
                    //                        .font(.system(.callout, design: .default))
                    //                        .foregroundColor(Color(hue: 0, saturation: 0, brightness: 0.301, opacity: 1))
                    //                        .submitLabel(.done) // Set the return key to "Done"
                    //                                        .onSubmit {
                    //                                            // Dismiss the keyboard by clearing the focus when "Done" is tapped
                    //                                            isTextFieldFocused = false
                    //                                        }
                }
                .padding(.horizontal)
                
                HStack {
                    Text("Voice")
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    Picker("Voice", selection: $callManager.voice) {
                        Text("🇺🇸 Alloy · Gentle American Man").tag("alloy")
                        Text("🇺🇸 Echo · Deep American Man").tag("echo")
                        Text("🇬🇧 Fable · Normal British Man").tag("fable")
                        Text("🇺🇸 Onyx · Deeper American Man").tag("onyx")
                        Text("🇺🇸 Nova · Gentle American Woman").tag("nova")
                        Text("🇺🇸 Shimmer · Deep American Woman").tag("shimmer")
                    }
                    .onReceive(callManager.$voice) { newVoice in
                        UserDefaults.standard.set(newVoice, forKey: "voice")
                    }
                    .multilineTextAlignment(.leading)
                }
                .padding(.horizontal)
                
                HStack {
                    Text("Speed")
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    Picker("Voice", selection: $callManager.speed) {
                        Text("🐇 Fast").tag(1.3)
                        Text("💬 Normal").tag(8.0)
                        Text("🐢 Slow").tag(0.3)
                        Text("⚡️ Superfast").tag(1.5)
                            .multilineTextAlignment(.leading)
                    } .onReceive(callManager.$speed) { newSpeed in
                        UserDefaults.standard.set(newSpeed, forKey: "speed")
                    }
                }
                .padding(.horizontal)
                
                Button(action: {
                    Task {
                        await callManager.handleCallAction()
                    }
                }) {
                    Text(callManager.buttonText)
                        .font(.system(.title2, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(callManager.buttonColor)
                        .cornerRadius(10)
                }
                .disabled(callManager.callState == .loading)
                .padding(.horizontal, 30)
                
                Spacer()
            }
            .onAppear {
                callManager.setupVapi()
            }
        } .background(Color(UIColor.systemGray6))
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

struct CustomTextEditor: UIViewRepresentable {
    @Binding var text: String
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        
        // Customize textView...
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.isScrollEnabled = true
        textView.isEditable = true
        textView.isUserInteractionEnabled = true
        textView.backgroundColor = UIColor.clear
        
        // Toolbar with Done button
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: context.coordinator, action: #selector(Coordinator.dismissKeyboard))
        toolbar.setItems([doneButton], animated: false)
        textView.inputAccessoryView = toolbar
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: CustomTextEditor
        
        init(_ textView: CustomTextEditor) {
            self.parent = textView
        }
        
        @objc func dismissKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        
        func textViewDidChange(_ textView: UITextView) {
            self.parent.text = textView.text
        }
    }
}
