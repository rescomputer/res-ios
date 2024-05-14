import Foundation
import Sentry

class SentryManager {
    static let shared = SentryManager()
    private init() {}
    private var enableDebugLogging = false

    // enableDebugLogging sends logs to sentry during local development (Debug builds)
    func start(enableDebugLogging: Bool = false) {
        self.enableDebugLogging = enableDebugLogging

        // Check if Sentry should be active considering the debug flag
        if Config.buildConfiguration == .release || enableDebugLogging {
            SentrySDK.start { options in
                options.dsn = Config.SENTRY_DSN
                options.debug = enableDebugLogging  // Control SDK debugging with the parameter
                options.enableTracing = true
            }
        }
    }
    
    var isSentryActive: Bool {
        return Config.buildConfiguration == .release || enableDebugLogging
    }
    
    func captureError(_ error: Error, description: String? = nil) {
        if isSentryActive {
            SentrySDK.capture(error: error) { scope in
                if let description = description {
                    scope.setExtra(value: description, key: "Description")
                }
            }
        } else {
            if let description = description {
                print("Error: \(error.localizedDescription), Description: \(description)")
            } else {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func captureMessage(_ message: String) {
        if isSentryActive {
            SentrySDK.capture(message: message)
        } else {
            print("Message: \(message)")
        }
    }
}
