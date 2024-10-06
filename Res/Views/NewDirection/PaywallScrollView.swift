//
//  PaywallScrollView.swift
//  Res
//
//  Created by Steven Sarmiento on 9/16/24.
//

import RevenueCat
import SwiftUI

struct PaywallScrollView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @Environment(\.dismiss) private var dismiss
    var dismissAction: () -> Void
    var onSuccessfulPurchase: () -> Void
    @State private var animateShine = false
    @State private var shouldDismiss = false

    var body: some View {

        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 1, green: 0.482, blue: 0.188),
                    Color(red: 0.945, green: 0.298, blue: 0.122),
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)

            VStack {
                Rectangle()
                    .fill(Color.white.opacity(0.5))
                    .frame(width: 40, height: 5)
                    .cornerRadius(2.5)
                    .padding(.top, 12)
                Spacer()
                    .frame(height: 120)
                paywallScrollContent()
                Spacer()
            }
        }
        //        .onChange(of: userViewModel.isSubscriptionActive) { oldValue, newValue in
        //            if newValue {
        //                print("Subscription became active, setting shouldDismiss to true")
        //                shouldDismiss = true
        //            }
        //        }
        //        .onChange(of: userViewModel.isSubscriptionActive) { oldValue, newValue in
        //            if newValue {
        //                dismissAction()
        //            }
        //        }
    }
}

extension PaywallScrollView {

    private func paywallScrollContent() -> some View {
        LazyVStack(alignment: .leading, spacing: 20) {
            // appIconView
            titleAndDescriptionView
        }
        .padding(.horizontal, 20)
    }

    @ViewBuilder
    private var appIconView: some View {
        if let appIcon = UIImage(named: "intelligence") {
            Image(uiImage: appIcon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.5), radius: 5)
        } else {
            Text("App Icon not found")
                .foregroundColor(.white)
        }
    }

    private var titleAndDescriptionView: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading, spacing: 5) {
                HStack(alignment: .top) {
                    Image("logo-res")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 140, height: 65)
                        .zIndex(1)
                    Text("Pro")
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .foregroundColor(.black.opacity(0.5))
                }
                // Text("Unlock Unlimited Calls")
                //     .font(.system(size: 32, weight: .regular, design: .rounded))
                //     .foregroundColor(.white)
                //     .padding(.top, 30)
                Text(
                    "Upgrade to RES Pro to enjoy unlimited calls with your contacts. Discover endless possibilities with diverse personalities, voices, and more."
                )
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(1))
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(0)
                .padding(.bottom, 20)

                Text(
                    "Payment is charged to the iTunes account associated with your device at confirmation of purchase. Subscription automatically renews unless auto-renew is turned off at least 24 hours before the end of the current period unless auto-renew is tuned off."
                )
                .font(.system(size: 9, weight: .regular))
                .foregroundColor(.white.opacity(0.7))
                .padding(.bottom, 5)

                Text(
                    "You can manage your subscription on your membership page or in your Account settings."
                )
                .font(.system(size: 9, weight: .regular))
                .foregroundColor(.white.opacity(0.7))
            }
        }
    }
    //    func handleSuccessfulPurchase() {
    //        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // 1 second delay
    //            self.userViewModel.updateSubscriptionStatus(force: true)
    //        }
    //        onSuccessfulPurchase()
    //        dismissAction()
    //    }
}
//
//#Preview {
//    PaywallScrollView(dismissAction: {}, onSuccessfulPurchase: {})
//}
