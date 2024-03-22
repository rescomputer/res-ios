//
//  HerApp.swift
//  Her
//
//  Created by Richard Burton on 03/05/2024.
//

import SwiftUI

@main
struct HerApp: App {
    @State private var isAppSettingsViewShowing = false
    
    var body: some Scene {
        WindowGroup {
            MainView(isAppSettingsViewShowing: $isAppSettingsViewShowing)
        }
    }
}
