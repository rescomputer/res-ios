//
//  CallManager.swift
//  Her
//
//  Created by Daniel Berezhnoy on 3/15/24.
//

import Combine
import SwiftUI
import Vapi
import ActivityKit

struct Her_ExtensionAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var sfSymbolName: String
    }
    
    var name: String
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
    
    @Published var activity: Activity<Her_ExtensionAttributes>?
    
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

    var voiceDisplayName: String {
        switch voice {
        case "alloy": return "🇺🇸 Alloy"
        case "echo": return "🇺🇸 Echo"
        case "fable": return "🇬🇧 Fable"
        case "onyx": return "🇺🇸 Onyx"
        case "nova": return "🇺🇸 Nova"
        case "shimmer": return "🇺🇸 Shimmer"
        default: return "Voice Type"
        }
    }

    var speedDisplayName: String {
        switch speed {
        case 0.3: return "🐢 Slow"
        case 1.0: return "💬 Normal"
        case 1.3: return "🐇 Fast"
        case 1.5: return "⚡️ Superfast"
        default: return "Voice Speed"
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
    
    @MainActor
    func handleCallAction() async {
        if callState == .ended {
            await startCall()
        } else {
            await endCall()
        }
    }
    
    @MainActor
    func startCall() async {
        callState = .loading
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
            "firstMessage": "Hey",
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
            // Start the live activity
            let activityAttributes = Her_ExtensionAttributes(name: "Conversation")
            let initialContentState = Her_ExtensionAttributes.ContentState(sfSymbolName: "ellipsis")
            activity = try Activity<Her_ExtensionAttributes>.request(
                attributes: activityAttributes,
                contentState: initialContentState
            )
        } catch {
            print("Error starting call or requesting activity: \(error)")
            callState = .ended
        }
    }
    
    func updateLiveActivity() {
        switch callState {
        case .started:
            let sfSymbolName = "waveform.and.person.filled"
            let updatedContentState = Her_ExtensionAttributes.ContentState(sfSymbolName: sfSymbolName)
            Task {
                await activity?.update(using: updatedContentState)
            }
        case .loading:
            let sfSymbolName = "ellipsis"
            let updatedContentState = Her_ExtensionAttributes.ContentState(sfSymbolName: sfSymbolName)
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
    
    func endCall()  {
        vapi.stop()
        Task {
            await activity?.end(dismissalPolicy: .immediate)
            DispatchQueue.main.async {
                self.activity = nil
            }
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
        callState == .loading ? Color(red: 1, green: 0.8, blue: 0.49) : (callState == .ended ? Color(red: 0.106, green: 0.149, blue: 0.149) : Color(red: 0.957, green: 0.298, blue: 0.424))
    }
}
