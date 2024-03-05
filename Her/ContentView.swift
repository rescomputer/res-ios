import SwiftUI
import AVFoundation

// MARK: - Vapi Service for API Integration
class VapiService {
    private let apiKey = "YOUR_API_KEY_HERE"
    private let baseUrl = "https://api.vapi.com"
    
    static let shared = VapiService()
    
    private init() {}
    
    func startCall(withAssistantId assistantId: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "\(baseUrl)/startCall") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(apiKey, forHTTPHeaderField: "Authorization")
        let body: [String: Any] = ["assistantId": assistantId]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data, let responseString = String(data: data, encoding: .utf8) else {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                    return
                }
                
                completion(.success(responseString))
            }
        }.resume()
    }
    
    // Add other methods as needed, e.g., stopCall
}

// MARK: - Audio Monitor for Microphone Input
class AudioMonitor {
    static let shared = AudioMonitor()
    private var audioEngine: AVAudioEngine?
    private var inputNode: AVAudioInputNode?
    
    private init() {}
    
    func requestMicrophoneAccess(completion: @escaping (Bool) -> Void) {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    func startMonitoringMicrophone() {
        audioEngine = AVAudioEngine()
        guard let audioEngine = audioEngine else { return }
        
        inputNode = audioEngine.inputNode
        let recordingFormat = inputNode!.inputFormat(forBus: 0)
        inputNode!.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            // Placeholder for analysis logic
            // Consider triggering Vapi API call here
        }
        
        do {
            try audioEngine.start()
        } catch {
            print("Could not start audio engine: \(error)")
        }
    }
    
    func stopMonitoringMicrophone() {
        audioEngine?.stop()
        inputNode?.removeTap(onBus: 0)
        // Handle stopping Vapi call here if needed
    }
}

// MARK: - SwiftUI ContentView
struct ContentView: View {
    @State private var isMonitoring = false
    
    var body: some View {
        VStack {
            Text(isMonitoring ? "Monitoring..." : "Start Monitoring")
                .padding()
                .foregroundColor(.white)
                .background(isMonitoring ? Color.red : Color.blue)
                .clipShape(Capsule())
                .onTapGesture {
                    if isMonitoring {
                        AudioMonitor.shared.stopMonitoringMicrophone()
                    } else {
                        AudioMonitor.shared.requestMicrophoneAccess { granted in
                            if granted {
                                AudioMonitor.shared.startMonitoringMicrophone()
                            } else {
                                print("Microphone access denied.")
                            }
                        }
                    }
                    isMonitoring.toggle()
                }
        }
        .padding()
    }
}

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
