import Foundation

struct Config {
    static var buildConfiguration: String {
        #if DEBUG
        return "Debug"
        #else
        return "Release"
        #endif
    }

    // Helper function to retrieve and validate config keys
    private static func getString(forKey key: String) -> String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? String else {
            fatalError("Missing key \(key) in Info.plist")
        }

        precondition(
            !value.isEmpty,
            """
            Key \(key) is present in Info.plist but is empty.
             - check that you've created corresponding .xcconfig files from the template.xcconfig files
             - check that the key \(key) is in your .xcconfig files and assigned a value.
            """
        )
        return value
    }

    static var SUPABASE_URL: String {
        return getString(forKey: "SUPABASE_URL")
    }

    static var SUPABASE_ANON_KEY: String {
        return getString(forKey: "SUPABASE_ANON_KEY")
    }

    static var SENTRY_DSN: String {
        return getString(forKey: "SENTRY_DSN")
    }
    
    static var DEBUG_USER_EMAIL: String {
        return getString(forKey: "DEBUG_USER_EMAIL")
    }
    
    static var DEBUG_USER_PASSWORD: String {
        return getString(forKey: "DEBUG_USER_PASSWORD")
    }
}
