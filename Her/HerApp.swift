//
//  HerApp.swift
//  Her
//
//  Created by Richard Burton on 03/05/2024.
//

import SwiftUI
import Intents

@main
struct HerApp: App {
    @StateObject private var callManager = CallManager()
    @State private var isAppSettingsViewShowing = false
    
    var body: some Scene {
        WindowGroup {
            MainView(isAppSettingsViewShowing: $isAppSettingsViewShowing)
                .environmentObject(callManager)
                .onOpenURL { url in
                    if url.scheme == "her" && url.host == "startCall" {
                        callManager.startCallFromShortcut()
                    }
                }
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Request Siri authorization and donate the intent
        INPreferences.requestSiriAuthorization { status in
            if status == .authorized {
                let intent = StartCallIntent()
                intent.suggestedInvocationPhrase = "Start call with Her"
                let interaction = INInteraction(intent: intent, response: nil)
                interaction.donate { error in
                    if let error = error {
                        print("Error donating interaction: \(error)")
                    } else {
                        print("Successfully donated interaction")
                    }
                }
            }
        }
        return true
    }
}
