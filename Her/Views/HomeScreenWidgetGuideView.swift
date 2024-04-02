//
//  HomeScreenWidgetGuideView.swift
//  Her
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
                            .cornerRadius(10)
                            //.padding(.bottom, 10)
                        
                        VStack {
                            Text("Add a home screen widget to your home screen to access Her quickly.")
                                .bold()
                                .font(.system(size: 18, design: .rounded))
                                .foregroundColor(Color.white.opacity(0.7))
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: 150, alignment: .center)

                    ScrollView {
                    VStack(alignment: .leading, spacing: 10) {  
                        HStack {
                            RoundedRectangle(cornerRadius: 13)
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color.white.opacity(0.1))
                                .overlay(
                                    Image(systemName: "hand.tap")
                                        .font(.system(size: 18))
                                        .foregroundColor(.white.opacity(0.5))

                                )
                            Text("Long-press on an empty space on your home screen an look for the '+' icon at the top-left corner of the screen. ")
                                .font(.system(size: 14))
                                .foregroundColor(Color.white.opacity(0.5))
                        }
                        Image("homescreen-step-one")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(10)
                            .padding(.bottom, 20)
                        
                        HStack {
                            RoundedRectangle(cornerRadius: 13)
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color.white.opacity(0.1))
                                .overlay(
                                    Image(systemName: "sparkle.magnifyingglass")
                                        .font(.system(size: 18))
                                        .foregroundColor(.white.opacity(0.5))

                                )
                            Text("Search for Her in the widget gallery and tap on it to see the widget options.")
                                .font(.system(size: 14))
                                .foregroundColor(Color.white.opacity(0.5))
                        }
                        Image("homescreen-step-two")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(10)
                            .padding(.bottom, 20) 

                        HStack {
                            RoundedRectangle(cornerRadius: 13)
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color.white.opacity(0.1))
                                .overlay(
                                    Image(systemName: "rectangle.grid.1x2")
                                        .font(.system(size: 18))
                                        .foregroundColor(.white.opacity(0.5))

                                )
                            Text("Choose the size that suits your preference – small, medium, or large – by tapping on it.")
                                .font(.system(size: 14))
                                .foregroundColor(Color.white.opacity(0.5))
                        }
                        Image("homescreen-step-three")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(10)
                            .padding(.bottom, 20)
                        // HStack {
                        //     RoundedRectangle(cornerRadius: 13)
                        //         .frame(width: 40, height: 40)
                        //         .foregroundColor(Color.white.opacity(0.1))
                        //         .overlay(
                        //             Image(systemName: "plus.square.on.square")
                        //                 .font(.system(size: 18))
                        //                 .foregroundColor(.white.opacity(0.5))

                        //         )
                        //     Text("Add to Home Screen: Tap 'Add Widget' to add the widget to your home screen. Drag it to your desired location and exit jiggle mode to enjoy instant access to your app's functionality.")
                        //         .font(.system(size: 14))
                        //         .foregroundColor(Color.white.opacity(0.5))
                        // }
                    }
                    .padding(.top, 10)                         
                    }                
   

                 Spacer()    
                 Spacer()                     
                 
                }
                .padding()
                .padding(.horizontal, 10)
                .slideLeft()

        }               
    }
}
