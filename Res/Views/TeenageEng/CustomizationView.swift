//
//  CustomizationView.swift
//  Res
//
//  Created by Steven Sarmiento on 6/10/24.
//

import SwiftUI

struct CustomizationView: View {
    var dismissAction: () -> Void

    var body: some View {

            ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [Color(red: 0.047, green: 0.071, blue: 0.071), Color(red: 0.047, green: 0.071, blue: 0.071)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .edgesIgnoringSafeArea(.all)

                VStack {
                Spacer()
                    .frame(height: 60)
                
                HStack {
                    Button(action: {
                        withAnimation(.easeOut(duration: 0.1)) {
                            self.dismissAction()                        
                        }
                        let impactMed = UIImpactFeedbackGenerator(style: .soft)
                        impactMed.impactOccurred()
                    }) {
                        HStack {
                            Image(systemName: "chevron.backward")
                                .font(.system(size: 20))
                                .bold()
                                .foregroundColor(.white.opacity(0.3))
                        }
                    }
                    Spacer()
                    
                    Text("Customization")
                        .bold()
                        .font(.system(size: 20, design: .rounded))
                        .foregroundColor(Color.white.opacity(0.8))
                    
                    
                    Spacer()

                    // Button(action: {
                    //     //action
                    //     let impactMed = UIImpactFeedbackGenerator(style: .soft)
                    //     impactMed.impactOccurred()
                    // }) {
                    //     HStack {
                    //         Image(systemName: "info.circle.fill")
                    //             .font(.system(size: 20))
                    //             .bold()
                    //             .foregroundColor(.white.opacity(0.3))
                    //     }
                    // }
                }
                .padding(.bottom, 20)
                
                customizationLinks()
                    
                Spacer()

            }
            .padding()
            .padding(.horizontal, 10)
        }
        .slideLeft()
    }
}

extension CustomizationView {
        private func customizationLinks() -> some View {
            VStack {
                    HStack {
                        Text("Tutorials")
                            .bold()
                            .font(.system(size: 12))
                            .foregroundColor(Color.white.opacity(0.7))
                        Spacer()
                    }
                    CustomLinkView(iconName: "paintbrush.fill", title: "Choose a Skin", action: {}, navigateTo: {
                        //self.selectedSetting = .homeScreen
                    }, screenSize: UIScreen.main.bounds.size, offset: 0, minHeight: 100)
                    CustomLinkView(iconName: "app.gift.fill", title: "Choose an Icon", action: {}, navigateTo: {
                        //self.selectedSetting = .lockScreen
                    }, screenSize: UIScreen.main.bounds.size, offset: 0, minHeight: 100)
            }
            .padding(.bottom, 20)

        } 
}


#Preview {
    CustomizationView(dismissAction: {})
}
