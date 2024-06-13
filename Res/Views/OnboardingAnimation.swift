//
//  OnboardingAnimation.swift
//  Res
//
//  Created by Steven Sarmiento on 6/6/24.
//

import SwiftUI
import RiveRuntime

struct OnboardingAnimation: View {
    var body: some View {
        RiveViewModel(fileName: "res_unboxing").view()
    }
}
