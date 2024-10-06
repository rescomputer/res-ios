//
//  ResApp.swift
//  Res
//
//  Created by Richard Burton on 03/05/2024.
//

import RevenueCat
import RevenueCatUI
import Sentry
import Supabase
import SwiftUI

class PurchasesDelegateHandler: NSObject, PurchasesDelegate {
    var userViewModel: UserViewModel

    init(userViewModel: UserViewModel) {
        self.userViewModel = userViewModel
    }

    func purchases(_ purchases: Purchases, receivedUpdated customerInfo: CustomerInfo) {
        DispatchQueue.main.async {
            self.userViewModel.updateSubscriptionStatus(force: true)
        }
    }
}

@main
struct ResApp: App {
    @StateObject private var resAppModel = ResAppModel()
    @StateObject private var callManager = CallManager()
    @StateObject var userViewModel = UserViewModel()

    private let purchasesDelegateHandler: PurchasesDelegateHandler

    // @State private var isChangelogViewShowing = false
    // @State private var isAppSettingsViewShowing = false
    // @State private var isModalStepTwoEnabled = false
    // @State private var hasCompletedOnboarding = false
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var isLaunchScreenPresented = true
    // let isDebugMode = Config.buildConfiguration == .debug

    init() {
        SentryManager.shared.start(enableDebugLogging: false)

        // Configure RevenueCat first
        Purchases.configure(
            with: Configuration.Builder(withAPIKey: Constants.apiKey)
                .with(usesStoreKit2IfAvailable: true)
                .build()
        )

        // Enable debug logs for RevenueCat (remove in production)
        Purchases.logLevel = .debug

        // Initialize UserViewModel
        let userVM = UserViewModel()
        self._userViewModel = StateObject(wrappedValue: userVM)

        // Create PurchasesDelegateHandler
        self.purchasesDelegateHandler = PurchasesDelegateHandler(userViewModel: userVM)

        // Set the delegate after configuration
        Purchases.shared.delegate = self.purchasesDelegateHandler
    }

    var body: some Scene {
        WindowGroup {
            if isLaunchScreenPresented && !hasCompletedOnboarding {
                LaunchScreenView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            withAnimation {
                                isLaunchScreenPresented = false
                            }
                        }
                    }
            } else if !hasCompletedOnboarding {
                OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
            } else {
                CallScreen()
                    .persistentSystemOverlays(.hidden)
                    .statusBarHidden(true)
                    .preferredColorScheme(.light)
            }
        }
        .environmentObject(resAppModel)
        .environmentObject(callManager)
        .environmentObject(userViewModel)

    }

    // MARK: - PurchasesDelegate Methods
    func purchases(_ purchases: Purchases, receivedUpdated customerInfo: CustomerInfo) {
        // Handle updated customer info
        DispatchQueue.main.async {
            userViewModel.updateSubscriptionStatus(force: true)
        }
    }

    // var body: some Scene {
    //     WindowGroup {
    //         if isLaunchScreenPresented && !resAppModel.isAuthenticated {
    //             LaunchScreenView()
    //                 .onAppear {
    //                     DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
    //                         withAnimation {
    //                             isLaunchScreenPresented = false
    //                         }
    //                     }
    //                 }
    //         } else if resAppModel.isAuthenticated || isDebugMode {
    //             CallScreen()
    //                 .persistentSystemOverlays(.hidden)
    //         } else {
    //             AuthView(
    //                 isChangelogViewShowing: $isChangelogViewShowing,
    //                 isAppSettingsViewShowing: $isAppSettingsViewShowing,
    //                 isModalStepTwoEnabled: $isModalStepTwoEnabled,
    //                 isDebugMode: isDebugMode
    //             )
    //         }
    //     }
    //     .environmentObject(resAppModel)
    //     .environmentObject(callManager)
    // }
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
