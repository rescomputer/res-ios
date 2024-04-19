//
//  HomeScreenWidgetGuideView.swift
//  Res
//
//  Created by Steven Sarmiento on 4/2/24.
//

import SwiftUI

struct HomeScreenWidgetGuideView: View {
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
                    
                    Text("Home Screen Widget")
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

                    //TODO add images or video of what the final widgets look like
                    ZStack {
                        Image("homescreen-widget-topper")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(15)
                            .padding(.bottom, 5)
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: 120, alignment: .center)

                    ScrollView {
                        homescreenContent()
                    } 
                    .applyScrollViewEdgeFadeDark()
                }
                .padding()
                .padding(.horizontal, 10)
                .slideLeft()

        }               
    }
}

extension HomeScreenWidgetGuideView {

    private func homescreenContent() -> some View {
        VStack {
            // Step 1
            timelineStep(iconName: "hand.tap.fill", description: "Long-press on an empty space on your home screen and look for the '+' icon at the top-left corner of the screen.", imageName: "homescreen-step-one")
            
            // Step 2
            timelineStep(iconName: "sparkle.magnifyingglass", description: "Search for Her in the widget gallery and tap on it to see the widget options.", imageName: "homescreen-step-two")
            
            // Step 3
            timelineStep(iconName: "rectangle.stack.fill", description: "Choose the size that suits your preference – small, medium, or large – by tapping on it.", imageName: "homescreen-step-three")
            
            // Step 4
            timelineStep(iconName: "hand.draw.fill", description: "Drag it to your desired location and exit jiggle mode to enjoy instant access to her whenever you want to talk.", imageName: "homescreen-step-four", isLastStep: true)
        }
        .padding(.top, 10)
    }

    private func timelineStep(iconName: String, description: String, imageName: String, isLastStep: Bool = false) -> some View {
        HStack(alignment: .top, spacing: 15) {
            VStack {
                RoundedRectangle(cornerRadius: 13)
                    .frame(width: 40, height: 40)
                    .foregroundColor(Color.white.opacity(0.1))
                    .overlay(
                        Image(systemName: iconName)
                            .font(.system(size: 18))
                            .foregroundColor(.white.opacity(0.5))

                    )
                RoundedRectangle(cornerRadius: 25)
                    .frame(width: 3, height: isLastStep ? 0 : .infinity)
                    .foregroundColor(Color.white.opacity(0.07))
            }
            .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 10) {
                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(Color.white.opacity(0.5))
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(15)
                    .padding(.bottom, 20)
            }
        }
    }
}
