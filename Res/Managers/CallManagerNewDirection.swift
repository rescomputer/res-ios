//
//  CallManager.swift
//  Res
//
//  Created by Daniel Berezhnoy on 3/15/24.
//

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

    init() {
        self.hipaaEnabled = UserDefaults.standard.bool(forKey: "hipaaEnabled")
    }

    enum CallState: String {
        case started, loading, ended
    }
    
    @Published var callState: CallState = .ended
    var vapiEvents = [Vapi.Event]()
    private var cancellables = Set<AnyCancellable>()
    var vapi: Vapi?

    var isAssistantSpeaking = false
    
    @Published var enteredText = ""

    @Published var activity: Activity<Res_ExtensionAttributesNew>?

    var selectedPersonaSystemPrompt: String = "" // Add this property

    /// used for wavelength view
    var remoteVolumeLevel: Float {
        vapi?.remoteAudioLevel ?? 0
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
                    self?.isAssistantSpeaking = false
                case .speechUpdate(let speechUpdate):
                    print(event)
                    if (speechUpdate.status == .stopped && speechUpdate.role == .assistant)
                        || speechUpdate.role == .user {
                        self?.isAssistantSpeaking = false
                    } else {
                        self?.isAssistantSpeaking = true
                    }
                case .conversationUpdate:
                    print(event)
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
                self?.updateLiveActivity()
            }
            .store(in: &cancellables)
        
        if let savedText = UserDefaults.standard.string(forKey: "enteredText"), !savedText.isEmpty {
            enteredText = savedText
        } else {
            enteredText = "A helpful assistant that gets to the point. Does not speak in bullet points. Answers clearly."
        }
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
    
    private func initializeVapiAndStartCall() async {
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
        }
    }
    
    func startObservingRemoteAudioLevel() async {
        do {
            try await vapi?.startRemoteParticipantsAudioLevelObserver()
        } catch {
            print(error)
        }
    }
    
    private func startCall() async {
        guard let vapi = vapi else {
            callState = .ended
            return
        }
        
        let assistant = [
            "model": [
                "provider": "openai",
                "model": "gpt-4o",
                "fallbackModels": [
                    "gpt-4-0125-preview",
                    "gpt-4-1106-preview"
                ],
                "messages": [
                    ["role": "system",
                     "content": selectedPersonaSystemPrompt] // Use the selected persona's system prompt
                ],
                "maxTokens": 1000, // Maximum
            ],
            "hipaaEnabled": UserDefaults.standard.bool(forKey: "hipaaEnabled"),
            "silenceTimeoutSeconds": 120,
            "maxDurationSeconds": 1800, // Maximum
            "numWordsToInterruptAssistant": 1,
            "responseDelaySeconds": 0,
            "llmRequestDelaySeconds": 0,
            "firstMessage": "What's up?",
            "voice": [
                "provider": "openai",
                "voiceId": "alloy",
                "speed": 1.0
            ],
            "transcriber": [
                "language": "en",
                "model": "nova-2",
                "provider": "deepgram"
            ]
        ] as [String: Any]
        
        do {
            let call = try await vapi.start(assistant: assistant)

            do {
                try await SupabaseManager.shared.insertCallRecord(callUUID: call.id)
            } catch {
                SentryManager.shared.captureError(error, description: "Error inserting call record into db")
            }
            
            setupVapi()
            stopPlayingSounds()
            
            // Start the live activity
            let activityAttributes = Res_ExtensionAttributesNew(name: "Conversation")
            let initialContentState = Res_ExtensionAttributesNew.ContentState(sfSymbolName: "ellipsis")
            
            activity = try Activity<Res_ExtensionAttributesNew>.request(attributes: activityAttributes, contentState: initialContentState)
            
        } catch {
            SentryManager.shared.captureError(error, description: "Error starting call")
            callState = .ended
        }
    }
    
    func updateLiveActivity() {
        switch callState {
        case .started:
            let sfSymbolName = "waveform.and.person.filled"
            let updatedContentState = Res_ExtensionAttributesNew.ContentState(sfSymbolName: sfSymbolName)
            Task {
                await activity?.update(using: updatedContentState)
            }
        case .loading:
            let sfSymbolName = "ellipsis"
            let updatedContentState = Res_ExtensionAttributesNew.ContentState(sfSymbolName: sfSymbolName)
            Task {
                await activity?.update(using: updatedContentState)
            }
        case .ended:
            Task {
                await activity?.end(dismissalPolicy: .immediate)
                activity = nil
            }
        }
    }

    func endCall() async {
        guard let vapi = vapi else {
            callState = .ended
            return
        }
        
        vapi.stop()
        Task {
            await activity?.end(dismissalPolicy: .immediate)
            DispatchQueue.main.async {
                self.activity = nil
            }
        }
    }
    
    private func playDialUpSound() {
        guard let path = Bundle.main.path(forResource: "dial.up.sound", ofType: "mp3") else {
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

extension CallManagerNewDirection {
    var callStateText: String {
        switch callState {
        case .started:
            "Connected"
        case .loading:
            "Connecting..."
        case .ended:
            "Chat with an AI back-and-forth"
        }
    }
    
    var buttonGradient: LinearGradient {
        switch callState {
        case .loading:
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.957, green: 0.522, blue: 0), Color(red: 0.961, green: 0.282, blue: 0)]), startPoint: .top, endPoint: .bottom)
        case .ended:
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.957, green: 0.522, blue: 0), Color(red: 0.961, green: 0.282, blue: 0)]), startPoint: .top, endPoint: .bottom)
        case .started:
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.957, green: 0.231, blue: 0), Color(red: 0.961, green: 0, blue: 0)]), startPoint: .top, endPoint: .bottom)
        }
    }
    
    @ViewBuilder
    var buttonText: some View {
        switch callState {
        case .loading:
            Loader()
                .frame(width: 42, height: 42)
                .scaleUpAnimation()
        case .ended:
            Image(systemName: "phone.fill")
                .foregroundStyle(.white.opacity(0.8))
                .scaleUpAnimation()
        case .started:
            Image(systemName: "phone.down.fill")
                .foregroundStyle(.white.opacity(0.8))
                .scaleUpAnimation()
        }
    }
}

struct Res_ExtensionAttributesNew: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var sfSymbolName: String
    }
    
    var name: String
}
