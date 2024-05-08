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
    init() {
        // if enableDebugLogging is true, log to sentry during local development
        SentryManager.shared.start(enableDebugLogging: false)

        // example usage:
        // SentryManager.shared.captureMessage("This app uses Sentry!")
    }
    @State private var isAppSettingsViewShowing = false
    @State private var isModalStepTwoEnabled = false
    
    var body: some Scene {
        WindowGroup {
            MainView(isAppSettingsViewShowing: $isAppSettingsViewShowing, isModalStepTwoEnabled: $isModalStepTwoEnabled)
        }
    }
}
