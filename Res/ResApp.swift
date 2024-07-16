//
//  ResApp.swift
//  Res
//
//  Created by Richard Burton on 03/05/2024.
//

import SwiftUI
import Sentry
import Supabase

@main
struct ResApp: App {
    @StateObject private var resAppModel = ResAppModel()
    @StateObject private var callManager = CallManager()

    @State private var isChangelogViewShowing = false
    @State private var isAppSettingsViewShowing = false
    @State private var isModalStepTwoEnabled = false
    @State private var hasCompletedOnboarding = false 
    @State private var isLaunchScreenPresented = true
    let isDebugMode = Config.buildConfiguration == .debug

    init() {
        SentryManager.shared.start(enableDebugLogging: false)
    }
    
    var body: some Scene {
        WindowGroup {
            if isLaunchScreenPresented && !resAppModel.isAuthenticated {
                LaunchScreenView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            withAnimation {
                                isLaunchScreenPresented = false
                            }
                        }
                    }
            } else if resAppModel.isAuthenticated || isDebugMode {
                PadsScreen()
                .persistentSystemOverlays(.hidden)
            } else {
                AuthView(
                    isChangelogViewShowing: $isChangelogViewShowing,
                    isAppSettingsViewShowing: $isAppSettingsViewShowing,
                    isModalStepTwoEnabled: $isModalStepTwoEnabled,
                    isDebugMode: isDebugMode
                )
            }
        }
        .environmentObject(resAppModel)
        .environmentObject(callManager)
    }
}

class ResAppModel: ObservableObject {
    @AppStorage("active_icon") var activeAppIcon: String = "AppIcon"
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
