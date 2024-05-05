//
//  ResApp.swift
//  Res
//
//  Created by Richard Burton on 03/05/2024.
//

import SwiftUI
import Supabase

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false

    init() {
        Task {
            await checkSession()
            await signOut()
        }
    }

    
    // Asynchronous function to check and refresh session
    func checkSession() async {
        do {
            let session = try await SupabaseService.shared.client.auth.refreshSession()
            isAuthenticated = true
            print("Session refreshed and found: \(session)")
        } catch {
            print("Error refreshing session: \(error)")
            isAuthenticated = false
        }
    }

    // Example function to sign out the user
    func signOut() {
        Task {
            do {
                try await SupabaseService.shared.client.auth.signOut()
                isAuthenticated = false
            } catch {
                print("Sign-out error: \(error)")
            }
        }
    }
}


@main
struct ResApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    
    @State private var isAppSettingsViewShowing = false
    @State private var isModalStepTwoEnabled = false

    var body: some Scene {
        WindowGroup {
            if authViewModel.isAuthenticated {
                MainView(isAppSettingsViewShowing: $isAppSettingsViewShowing, isModalStepTwoEnabled: $isModalStepTwoEnabled)
            } else {
                AuthView()
                    .environmentObject(authViewModel)
            }
        }
    }
}
