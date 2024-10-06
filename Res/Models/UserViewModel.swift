//
//  UserViewModel.swift
//  Res
//
//  Created by Steven Sarmiento on 9/19/24.
//

import Foundation
import SwiftUI
import RevenueCat

class UserViewModel: ObservableObject {
    @Published var customerInfo: CustomerInfo?
    @Published var isSubscriptionActive = false
    @Published var subscriptionType: String?
    @Published var userEmail: String?
    @Published var expirationDate: String = "N/A"
    @Published var originalAppUserId: String?
    @Published var firstSeen: Date?
    @Published var originalApplicationVersion: String?
    @Published var originalPurchaseDate: Date?
    @Published var managementURL: URL?
    @Published var allPurchasedProductIdentifiers: Set<String> = []
    @Published var activeSubscriptions: Set<String> = []
    @Published var latestExpirationDate: Date?
    private var lastFetchTime: Date?
    private let fetchInterval: TimeInterval = 300
    
    init() {
        updateSubscriptionStatus(force: true)
    }
    
    func updateSubscriptionStatus(force: Bool = false) {
        let now = Date()
        guard force || lastFetchTime == nil || now.timeIntervalSince(lastFetchTime!) > fetchInterval else {
            return
        }
        
        Purchases.shared.getCustomerInfo { [weak self] (customerInfo, error) in
            guard let self = self, let customerInfo = customerInfo else { return }
            
            DispatchQueue.main.async {
                self.customerInfo = customerInfo
                self.isSubscriptionActive = customerInfo.entitlements.all["pro"]?.isActive == true
                self.subscriptionType = customerInfo.entitlements.all["pro"]?.productIdentifier
                self.userEmail = customerInfo.originalAppUserId
                self.updateExpirationDate(customerInfo: customerInfo)
                self.updateAdditionalInfo(customerInfo: customerInfo)
                self.lastFetchTime = now
            }
        }
    }

    private func updateExpirationDate(customerInfo: CustomerInfo) {
        if let expirationDate = customerInfo.entitlements.all["pro"]?.expirationDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            self.expirationDate = dateFormatter.string(from: expirationDate)
        } else {
            self.expirationDate = "N/A"
        }
    }
    
    private func updateAdditionalInfo(customerInfo: CustomerInfo) {
        self.originalAppUserId = customerInfo.originalAppUserId
        self.firstSeen = customerInfo.firstSeen
        self.originalApplicationVersion = customerInfo.originalApplicationVersion
        self.originalPurchaseDate = customerInfo.originalPurchaseDate
        self.managementURL = customerInfo.managementURL
        self.allPurchasedProductIdentifiers = customerInfo.allPurchasedProductIdentifiers
        self.activeSubscriptions = customerInfo.activeSubscriptions
        self.latestExpirationDate = customerInfo.latestExpirationDate
    }

    func refreshSubscriptionStatus() {
        updateSubscriptionStatus()
    }


    func getReadableSubscriptionType() -> String {
        guard let subscriptionType = subscriptionType else {
            return "Active Subscription"
        }
        
        switch subscriptionType {
        case "res_599_1w":
            return "Renewed Weekly @ $5.99"
        case "res_1999_1m":
            return "Renewed Monthly @ $19.99"
        default:
            return "Active Subscription"
        }
    }
    
    func getEntitlementInfo() -> EntitlementInfo? {
        return customerInfo?.entitlements.all["pro"]
    }
    
    func getEntitlementPeriodType() -> String {
        guard let entitlement = getEntitlementInfo() else { return "Unknown" }
        switch entitlement.periodType {
        case .trial: return "Trial"
        case .intro: return "Intro"
        case .normal: return "Normal"
        @unknown default: return "Unknown"
        }
    }
    
    func getEntitlementStore() -> String {
        guard let entitlement = getEntitlementInfo() else { return "Unknown" }
        switch entitlement.store {
        case .appStore: return "App Store"
        case .macAppStore: return "Mac App Store"
        case .playStore: return "Play Store"
        case .stripe: return "Stripe"
        case .promotional: return "Promotional"
        case .unknownStore: return "Unknown"
        @unknown default: return "Unknown"
        }
    }
    
    func isEntitlementAutoRenewing() -> Bool {
        return getEntitlementInfo()?.willRenew ?? false
    }
    
    func getFormattedFirstSeen() -> String {
        guard let firstSeen = firstSeen else { return "N/A" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: firstSeen)
    }
}
