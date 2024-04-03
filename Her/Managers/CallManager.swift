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
    
    enum VoiceProvider: String, CaseIterable {
        case openai, playht, rimeAi
    }

    struct Voice: Hashable {
        let id: String
        let name: String
    }

    @Published var voiceProvider: VoiceProvider = .openai {
        didSet {
            UserDefaults.standard.set(voiceProvider.rawValue, forKey: "voiceProvider")
        }
    }

    @Published var voice: Voice = Voice(id: "alloy", name: "Alloy · Gentle American Man") {
        didSet {
            UserDefaults.standard.set(voice.id, forKey: "voice")
        }
    }

    let voices: [VoiceProvider: [Voice]] = [
        .openai: [
            Voice(id: "alloy", name: "Alloy · Gentle American Man"),
            Voice(id: "echo", name: "Echo · Deep American Man"),
            Voice(id: "fable", name: "Fable · Normal British Man"),
            Voice(id: "onyx", name: "Onyx · Deeper American Man"),
            Voice(id: "nova", name: "Nova · Gentle American Woman"),
            Voice(id: "shimmer", name: "Shimmer · Deep American Woman")
        ],
        .playht: [
            Voice(id: "jennifer", name: "Jennifer · American Woman"),
            Voice(id: "will", name: "Will · Deep American Man"),
            Voice(id: "michael", name: "Michael · Normal American Man"),
            Voice(id: "ruby", name: "Ruby · Australian Woman")
        ],
        .rimeAi: [
            Voice(id: "eva", name: "Eva · American Woman"),
            Voice(id: "madison", name: "Madison · American Woman"),
            Voice(id: "selena", name: "Selena · American Woman"),
            Voice(id: "colin", name: "Colin · American Man"),
            Voice(id: "nicholas", name: "Nicholas · American Man"),
            Voice(id: "sharon", name: "Sharon · British Woman"),
            Voice(id: "maya", name: "Maya · British Woman")
        ]
    ]

    let speedRanges: [VoiceProvider: ClosedRange<Double>] = [
        .openai: 0.0...2.0,
        .playht: 0.0...5.0,
        .rimeAi: 0.0...2.0
    ]

    let speedPresets: [VoiceProvider: [String: Double]] = [
        .openai: [
            "🐢 Slow": 0.3,
      "💬 Normal": 1.0,
            "🐇 Fast": 1.3,
            "⚡️ Superfast": 1.5
        ],
        .playht: [
            "🐢 Slow": 2.0,
            "💬 Normal": 2.5,
            "🐇 Fast": 3.0,
            "⚡️ Superfast": 3.5
        ],
        .rimeAi: [
            "🐢 Slow": 1.5,
            "💬 Normal": 1.0,
            "🐇 Fast": 0.8,
            "⚡️ Superfast": 0.6
        ]
    ]
    
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
        if let savedVoiceProvider = UserDefaults.standard.string(forKey: "voiceProvider") {
            voiceProvider = VoiceProvider(rawValue: savedVoiceProvider) ?? .openai
        }
        if let savedVoice = UserDefaults.standard.string(forKey: "voice") {
            voice = voices[voiceProvider]?.first(where: { $0.id == savedVoice }) ?? Voice(id: "alloy", name: "Alloy · Gentle American Man")
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
            await endCall()
        }
    }
    
    @MainActor
    func startCall() async {
        callState = .loading
        let assistant = [
            "model": [
                "provider": voiceProvider.rawValue,
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
                "voiceId": voice.id,
                "provider": voiceProvider.rawValue,
                "speed": speed
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
                await activity?.end(using: Her_ExtensionAttributes.ContentState(sfSymbolName: "checkmark"), dismissalPolicy: .default)
            }
        }
    }
    
    @MainActor
    func endCall() async {
        do {
            try await vapi.stop()
        } catch {
            print("Error ending call: \(error)")
        }
    }
    
    var voiceDisplayName: String {
        voice.name
    }
    
    var speedDisplayName: String {
        let presets = speedPresets[voiceProvider] ?? [:]
        return presets.first(where: { $0.value == speed })?.key ?? "Voice Speed"
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
