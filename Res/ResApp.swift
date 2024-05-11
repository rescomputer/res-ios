//
//  ResApp.swift
//  Res
//
//  Created by Richard Burton on 03/05/2024.
//

import SwiftUI
import Sentry


@main
struct ResApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var isAppSettingsViewShowing = false
    @State private var isModalStepTwoEnabled = false
    
    init() {
        // if enableDebugLogging is true, log to sentry during local development
        SentryManager.shared.start(enableDebugLogging: false)
        // example usage:
        // SentryManager.shared.captureMessage("This app uses Sentry!")
    }
    
    var body: some Scene {
        WindowGroup {
            if let _ = authViewModel.currentSessionUID {
                MainView(isAppSettingsViewShowing: $isAppSettingsViewShowing, isModalStepTwoEnabled: $isModalStepTwoEnabled)
            } else {
                AuthView(viewModel: authViewModel, isDebugMode: true)
            }
        }
    }
}
