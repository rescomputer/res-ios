import Foundation

struct Config {
    // Constants for Info.plist keys
    private static let supabaseUrlKey = "SUPABASE_URL"
    private static let supabaseAnonKey = "SUPABASE_ANON_KEY"

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
        return getString(forKey: supabaseUrlKey)
    }

    static var SUPABASE_ANON_KEY: String {
        return getString(forKey: supabaseAnonKey)
    }
}
