import Foundation
import Supabase

enum SupabaseService {
    static let shared = SupabaseClient(
        supabaseURL: Config.supabaseURL,
        supabaseKey: Config.supabaseAnonKey
    )
}
