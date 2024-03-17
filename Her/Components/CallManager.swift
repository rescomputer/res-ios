//
//  CallManager.swift
//  Her
//
//  Created by Daniel Berezhnoy on 3/15/24.
//

import Combine
import SwiftUI
import Vapi

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
//                "provider": "groq",
//                "model": "mixtral-8x7b-32768",
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
        } catch {
            print("Error starting call: \(error)")
            callState = .ended
        }
    }
    
    func endCall() {
        vapi.stop()
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
