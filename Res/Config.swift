import Foundation

struct Config {
    // Constants for Info.plist keys
    private static let supabaseUrlKey = "SUPABASE_URL"
    private static let supabaseAnonKey = "SUPABASE_ANON_KEY"

    // Build configuration property
    static var buildConfiguration: String {
        #if DEBUG
        return "Debug"
        #else
        return "Release"
        #endif
    }

    // Helper function to retrieve and validate a key
    private static func getString(forKey key: String) -> String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? String else {
            fatalError("Missing key \(key) in Info.plist")
        }
        print(value)
        print(value)
        

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

    // SUPABASE_URL property
    static var SUPABASE_URL: String {
        return getString(forKey: supabaseUrlKey)
    }

    // SUPABASE_ANON_KEY property
    static var SUPABASE_ANON_KEY: String {
        return getString(forKey: supabaseAnonKey)
    }
}
