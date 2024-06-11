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

@MainActor class CallManager: ObservableObject {
    var audioPlayer: AVAudioPlayer?
    
    @Published var currentTranscript: String = ""
    
    enum CallState: String {
        case started, loading, ended
    }
    
    @Published var callState: CallState = .ended
    var vapiEvents = [Vapi.Event]()
    private var cancellables = Set<AnyCancellable>()
    var vapi: Vapi?
    
    
    var isAssistantSpeaking = false
    
    @Published var enteredText = ""
    
    @Published var activity: Activity<Res_ExtensionAttributes>?
    
    @Published var speed: Double = 1.0 {
        didSet {
            UserDefaults.standard.set(speed, forKey: "speed")
        }
    }
    
    @Published var voice: String = "alloy" {
        didSet {
            UserDefaults.standard.set(voice, forKey: "voice")
        }
    }

    var remoteVolumeLevel: Float {
        vapi?.remoteAudioLevel ?? 0
    }
    
    var voiceDisplayName: String {
        switch voice {
        case "alloy":
            return "🇺🇸 Alloy"
        case "echo":
            return "🇺🇸 Echo"
        case "fable":
            return "🇬🇧 Fable"
        case "onyx":
            return "🇺🇸 Onyx"
        case "nova":
            return "🇺🇸 Nova"
        case "shimmer":
            return "🇺🇸 Shimmer"
        default:
            return "Voice Type"
        }
    }
    
    var speedDisplayName: String {
        switch speed {
        case 0.3:
            return "🐢 Slow"
        case 1.0:
            return "💬 Normal"
        case 1.3:
            return "🐇 Fa st"
        case 1.5:
            return "⚡️ Superfast"
        default:
            return "Voice Speed"
        }
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
                    //
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
    
    func playVoicePreview() {
        // Implementation depends on the capabilities of Vapi or another audio library.
        // This method should generate and play a short audio clip using the selected voice and speed settings.
    }
    
    func handleCallAction() async {
        if callState == .ended {
            await initializeVapiAndStartCall()
        } else {
            await endCall()
        }
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
                "model": "gpt-4-0613",
                "fallbackModels" : [
                    "gpt-4-0125-preview",
                    "gpt-4-1106-preview"
                ],
                "messages": [
                    ["role":"system",
                     "content":enteredText]
                ],
                "maxTokens": 1000, //Maximum
            ],
            "silenceTimeoutSeconds": 120,
            "maxDurationSeconds": 1800, //Maximum
            "numWordsToInterruptAssistant": 1,
            "responseDelaySeconds": 0,
            "llmRequestDelaySeconds": 0,
            "firstMessage": "What's up? ",
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
            let call = try await vapi.start(assistant: assistant)

            do {
                try await SupabaseManager.shared.insertCallRecord(callUUID: call.id)
            } catch {
                SentryManager.shared.captureError(error, description: "Error inserting call record into db")
            }
            
            setupVapi()
            stopPlayingSounds()
            
            // Start the live activity
            let activityAttributes = Res_ExtensionAttributes(name: "Conversation")
            let initialContentState = Res_ExtensionAttributes.ContentState(sfSymbolName: "ellipsis")
            
            activity = try Activity<Res_ExtensionAttributes>.request(attributes: activityAttributes, contentState: initialContentState)
            
        } catch {
            SentryManager.shared.captureError(error, description: "Error starting call")
            callState = .ended
        }
    }
    
    func updateLiveActivity() {
        switch callState {
        case .started:
            let sfSymbolName = "waveform.and.person.filled"
            let updatedContentState = Res_ExtensionAttributes.ContentState(sfSymbolName: sfSymbolName)
            Task {
                await activity?.update(using: updatedContentState)
            }
        case .loading:
            let sfSymbolName = "ellipsis"
            let updatedContentState = Res_ExtensionAttributes.ContentState(sfSymbolName: sfSymbolName)
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
            
            //            audioPlayer = try AVAudioPlayer(contentsOf: url)
            //            audioPlayer?.delegate = self
            //            audioPlayer?.play()
            //            self.completionHandler = completion
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func stopPlayingSounds() {
        audioPlayer?.stop()
    }
    
    //    TODO: Enable the full length playback
    //    // AVAudioPlayerDelegate method
    //    private var completionHandler: (() -> Void)?
    //
    //    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    //        completionHandler?()
    //    }
}

extension CallManager {
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
    
    //Res Classic
    // var buttonText: String {
    //     callState == .loading ? "Connecting" : (callState == .ended ? "Start Conversation" : "End Conversation")
    // }
}

struct Res_ExtensionAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var sfSymbolName: String
    }
    
    var name: String
}
