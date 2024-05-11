//
//  ResApp.swift
//  Res
//
//  Created by Richard Burton on 03/05/2024.
//

import SwiftUI
import Sentry
import Supabase

class ResAppModel: ObservableObject {
    @Published var isAuthenticated = false
    private var authStateChangesTask: Task<Void, Never>? = nil

    init() {
        handleAuthStateChanges()
    }

    func handleAuthStateChanges() {
        authStateChangesTask = Task {
            for await (_, session) in SupabaseManager.shared.client.auth.authStateChanges {
                DispatchQueue.main.async {
                    self.isAuthenticated = (session != nil)
                }
            }
        }
    }
}


@main
struct ResApp: App {
    @StateObject private var resAppModel = ResAppModel()
    @State private var currentSessionUID: String?
    @State private var isAppSettingsViewShowing = false
    @State private var isModalStepTwoEnabled = false
    
    init() {
        // if enableDebugLogging is true, log to sentry during local development
        SentryManager.shared.start(enableDebugLogging: false)
    }
    
    var body: some Scene {
        WindowGroup {
            if resAppModel.isAuthenticated {
                MainView(isAppSettingsViewShowing: $isAppSettingsViewShowing, isModalStepTwoEnabled: $isModalStepTwoEnabled)
            } else {
                AuthView(isDebugMode: true)
            }
        }
    }
}
