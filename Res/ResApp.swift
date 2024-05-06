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
        SentrySDK.start { options in
            options.dsn = Config.SENTRY_DSN
            options.debug = true // Enabled debug when first installing is always helpful
            options.enableTracing = true 

            // Uncomment the following lines to add more data to your events
            // options.attachScreenshot = true // This adds a screenshot to the error events
            // options.attachViewHierarchy = true // This adds the view hierarchy to the error events
        }
        // example usage:
        // SentrySDK.capture(message: "This app uses Sentry!")
    }
    @State private var isAppSettingsViewShowing = false
    @State private var isModalStepTwoEnabled = false
    
    var body: some Scene {
        WindowGroup {
            MainView(isAppSettingsViewShowing: $isAppSettingsViewShowing, isModalStepTwoEnabled: $isModalStepTwoEnabled)
        }
    }
}
