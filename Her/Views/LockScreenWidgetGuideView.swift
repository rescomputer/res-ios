//
//  LockScreenWidgetGuideView.swift
//  Her
//
//  Created by Steven Sarmiento on 4/2/24.
//

import SwiftUI

struct LockScreenWidgetGuideView: View {
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
                    
                    Text("Lock Screen Widget")
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
                        Image("lockscreen-widget-topper")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(15)
                            .padding(.bottom, 5)
                        
                        // VStack {
                        //     Text("Add a widget to your lock screen to access Her quickly on the go.")
                        //         .bold()
                        //         .font(.system(size: 18, design: .rounded))
                        //         .foregroundColor(Color.white.opacity(0.7))
                        //         .multilineTextAlignment(.center)
                        //         .frame(maxWidth: .infinity)
                        // }
                    }
                    .frame(maxWidth: .infinity, maxHeight: 120, alignment: .center)

                    ScrollView {
                        lockscreenContent()
                    }
                    .applyScrollViewEdgeFadeDark()               
   

                 Spacer()    
                 Spacer()                     
                 
                }
                .padding()
                .padding(.horizontal, 10)
                .slideLeft()

        }   
    }
}

extension LockScreenWidgetGuideView {
    private func lockscreenContent() -> some View {
                    VStack(alignment: .leading, spacing: 10) {  
                        HStack {
                            RoundedRectangle(cornerRadius: 13)
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color.white.opacity(0.1))
                                .overlay(
                                    Image(systemName: "lock.fill")
                                        .font(.system(size: 18))
                                        .foregroundColor(.white.opacity(0.5))

                                )
                            Text("Wake your iPhone and press and hold on the lock screen, press customize at the bottom.")
                                .font(.system(size: 14))
                                .foregroundColor(Color.white.opacity(0.5))
                        }
                        Image("lockscreen-step-one")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(15)
                            .padding(.bottom, 20)
                        
                        HStack {
                            RoundedRectangle(cornerRadius: 13)
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color.white.opacity(0.1))
                                .overlay(
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 18))
                                        .foregroundColor(.white.opacity(0.5))

                                )
                            Text("Add a widget to your lock screen, by selecting the Add Widget option.")
                                .font(.system(size: 14))
                                .foregroundColor(Color.white.opacity(0.5))
                        }
                        Image("lockscreen-step-two")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(15)
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
                        Image("lockscreen-step-three")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(15)
                            .padding(.bottom, 20)

                       HStack {
                            RoundedRectangle(cornerRadius: 13)
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color.white.opacity(0.1))
                                .overlay(
                                    Image(systemName: "hand.draw.fill")
                                        .font(.system(size: 18))
                                        .foregroundColor(.white.opacity(0.5))

                                )
                            Text("Drag it to your desired location and exit the lockscreen custimzation mode.")
                                .font(.system(size: 14))
                                .foregroundColor(Color.white.opacity(0.5))
                        }

                        Image("lockscreen-step-four")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(15)
                            .padding(.bottom, 20)
                    }
                    .padding(.top, 10)   
    }
}

