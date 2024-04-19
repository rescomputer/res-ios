//
//  HerApp.swift
//  Res
//
//  Created by Richard Burton on 03/05/2024.
//

import SwiftUI

@main
struct HerApp: App {
    @State private var isAppSettingsViewShowing = false
    @State private var isModalStepTwoEnabled = false
    
    var body: some Scene {
        WindowGroup {
            MainView(isAppSettingsViewShowing: $isAppSettingsViewShowing, isModalStepTwoEnabled: $isModalStepTwoEnabled)
        }
    }
}
