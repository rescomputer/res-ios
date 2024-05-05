import Foundation
import Supabase

class SupabaseService {
    static let shared = SupabaseService()

    private(set) var client: SupabaseClient

    private init() {
        self.client = SupabaseClient(
            supabaseURL: URL(string: Config.SUPABASE_URL)!,
            supabaseKey: Config.SUPABASE_ANON_KEY
        )
    }
}
