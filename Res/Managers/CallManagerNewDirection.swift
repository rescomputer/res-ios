import Combine
import SwiftUI
import Vapi
import ActivityKit
import AVFoundation

@MainActor class CallManagerNewDirection: ObservableObject {
    var audioPlayer: AVAudioPlayer?
    @Published var currentTranscript: String = ""
    @Published var hipaaEnabled: Bool {
        didSet {
            UserDefaults.standard.set(hipaaEnabled, forKey: "hipaaEnabled")
            let savedValue = UserDefaults.standard.bool(forKey: "hipaaEnabled")
            print("Saved hipaaEnabled to UserDefaults: \(savedValue)")
        }
    }
        
    @Published var model: String {
        didSet {
            UserDefaults.standard.set(model, forKey: "model")
        }
    }
    
    @Published var fallbackModels: [String] {
        didSet {
            UserDefaults.standard.set(fallbackModels, forKey: "fallbackModels")
        }
    }
    
    @Published var firstMessage: String {
        didSet {
            UserDefaults.standard.set(firstMessage, forKey: "firstMessage")
        }
    }
    
    @Published var voiceProvider: String {
        didSet {
            UserDefaults.standard.set(voiceProvider, forKey: "voiceProvider")
        }
    }
    
    @Published var voiceId: String {
        didSet {
            UserDefaults.standard.set(voiceId, forKey: "voiceId")
        }
    }
    
    @Published var voiceModel: String? {
        didSet {
            UserDefaults.standard.set(voiceModel, forKey: "voiceModel")
        }
    }

    enum CallState: String {
        case started, loading, ended
    }
    enum ConversationState: String {
        case assistantSpeaking, assistantThinking, userSpeaking, null
    }
    
    @Published var callState: CallState = .ended
    @Published var conversationState: ConversationState = .null
    
    var vapiEvents = [Vapi.Event]()
    private var cancellables = Set<AnyCancellable>()
    var vapi: Vapi?
    
    var selectedPersona: Persona?

    public var remoteAudioLevel: Float {
        self.conversationState == .assistantSpeaking ? (vapi?.remoteAudioLevel ?? 0) : 0
    }
    public var localAudioLevel: Float {
        self.conversationState == .userSpeaking ? (vapi?.localAudioLevel ?? 0) : 0
    }

    init() {
        self.hipaaEnabled = UserDefaults.standard.bool(forKey: "hipaaEnabled")
        self.model = UserDefaults.standard.string(forKey: "model") ?? "gpt-4o"
        self.fallbackModels = UserDefaults.standard.stringArray(forKey: "fallbackModels") ?? ["gpt-4-0125-preview", "gpt-4-1106-preview"]
        self.firstMessage = UserDefaults.standard.string(forKey: "firstMessage") ?? "Hello!"
        self.voiceProvider = UserDefaults.standard.string(forKey: "voiceProvider") ?? "defaultProvider"
        self.voiceId = UserDefaults.standard.string(forKey: "voiceId") ?? "defaultVoiceId"
        self.voiceModel = UserDefaults.standard.string(forKey: "voiceModel")
    }

    func setupVapi() {
        guard let vapi else {
            print("Vapi is not initialized - setupVapi")
            DispatchQueue.main.async {
                self.callState = .ended
            }
            return
        }
        
        vapi.eventPublisher
            .sink { [weak self] event in
                self?.vapiEvents.append(event)
                switch event {
                case .callDidStart:
                    self?.callState = .started
                case .callDidEnd:
                    self?.callState = .ended
                    self?.conversationState = .null
                case .speechUpdate(let speechUpdate):
                    print(speechUpdate)
                    if speechUpdate.role == .assistant {
                        if speechUpdate.status == .started {
                            self?.conversationState = .assistantSpeaking
                        } else {
                            self?.conversationState = .null
                        }
                    } else if (speechUpdate.role == .user) {
                        if speechUpdate.status == .started {
                            self?.conversationState = .userSpeaking
                        } else {
                            self?.conversationState = .assistantThinking
                        }
                    }
                case .conversationUpdate(let conversationUpdateEventt):
                    print(conversationUpdateEventt)
                case .functionCall:
                    print(event)
                case .hang:
                    print(event)

                case .metadata:
                    print(event)
                case .transcript(let transcriptEvent):
                    DispatchQueue.main.async {
                        self?.currentTranscript = transcriptEvent.transcript
                    }
                case .error(let error):
                    SentryManager.shared.captureError(error, description: "VAPI reported an error")
                }
            }
            .store(in: &cancellables)
    }
    
    func handleCallAction() async {
        if callState == .ended {
            await initializeVapiAndStartCall()
        } else {
            await endCall()
        }
    }
    
    func handleStartCall() async {
        await initializeVapiAndStartCall()
    }
    
    func initializeVapiAndStartCall() async {
        callState = .loading
        playDialUpSound()
        
        do {
            let jwt = try await SupabaseManager.shared.issueVapiToken()
            vapi = Vapi(publicKey: jwt)
            await startCall()
        } catch {
            print("Failed to initialize Vapi or start call with error: \(error)")
            callState = .ended
        }

        Task {
            await startObservingRemoteAudioLevel()
            await startObservingLocalAudioLevel()
        }
    }
    
    func startObservingRemoteAudioLevel() async {
        do {
            try await vapi?.startRemoteParticipantsAudioLevelObserver()
        } catch {
            print(error)
        }
    }
    
    func startObservingLocalAudioLevel() async {
        do {
            try await vapi?.startLocalAudioLevelObserver()
        } catch {
            print(error)
        }
    }
    
    private func startCall() async {
        guard let vapi = vapi, let selectedPersona = selectedPersona else {
            callState = .ended
            return
        }
        
        var voiceDictionary: [String: Any] = [
            "provider": selectedPersona.voice.provider,
            "voiceId": selectedPersona.voice.id
        ]

        if let model = selectedPersona.voice.model {
            voiceDictionary["model"] = model
        }
        
        let assistant: [String: Any] = [
            "model": [
                "provider": "openai",
                "model": model,
                "fallbackModels": fallbackModels,
                "messages": [
                    ["role": "system",
                     "content": selectedPersona.systemPrompt]
                ],
                "maxTokens": 1000
            ],
            "hipaaEnabled": hipaaEnabled,
            "silenceTimeoutSeconds": 120,
            "maxDurationSeconds": 1800,
            "numWordsToInterruptAssistant": 1,
            "responseDelaySeconds": 0,
            "llmRequestDelaySeconds": 0,
            "firstMessage": firstMessage,
            "voice": voiceDictionary,
            "transcriber": [
                "language": "en",
                "model": "nova-2",
                "provider": "deepgram"
            ]
        ]
        
        do {
            let call = try await vapi.start(assistant: assistant)

            do {
                try await SupabaseManager.shared.insertCallRecord(callUUID: call.id)
            } catch {
                SentryManager.shared.captureError(error, description: "Error inserting call record into db")
            }
            
            setupVapi()
            stopPlayingSounds()
        } catch {
            SentryManager.shared.captureError(error, description: "Error starting call")
            callState = .ended
        }
    }

    func endCall() async {
        guard let vapi = vapi else {
            callState = .ended
            return
        }
        
        vapi.stop()
    }
    
    private func playDialUpSound() {
        guard let path = Bundle.main.path(forResource: "dial.up.sound", ofType: "m4a") else {
            return
        }
        
        let url = URL(fileURLWithPath: path)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func stopPlayingSounds() {
        audioPlayer?.stop()
    }
}
