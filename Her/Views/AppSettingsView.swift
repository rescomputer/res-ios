//
//  AppSettingsView.swift
//  Her
//
//  Created by Steven Sarmiento on 3/21/24.
//

import Foundation
import SwiftUI

struct AppSettingsView: View {
    @Binding var isPresented: Bool

    @Namespace var animation
    
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
                    .frame(height: 50)
                
                HStack {
                    Button(action: {
                        isPresented = false
                        let impactMed = UIImpactFeedbackGenerator(style: .soft)
                        impactMed.impactOccurred()
                    }) {
                        HStack {
                            Image(systemName: "xmark")
                                .font(.system(size: 20))
                                .bold()
                                .foregroundColor(.white.opacity(0.3))
                        }
                    }
                    Spacer()
                    
                    Text("Settings")
                        .bold()
                        .font(.system(size: 20, design: .rounded))
                        .foregroundColor(Color.white.opacity(0.8))
                    
                    
                    Spacer()

                    Button(action: {
                        //action
                        let impactMed = UIImpactFeedbackGenerator(style: .soft)
                        impactMed.impactOccurred()
                    }) {
                        // HStack {
                        //     Image(systemName: "party.popper.fill")
                        //         .font(.system(size: 20))
                        //         .bold()
                        //         .foregroundColor(.white.opacity(0.3))
                        // }
                    }
                }
                .padding(.bottom, 20)

                VStack(alignment: .leading, spacing: 10) {
                        Text("This app is built using:")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.6))
                        
                        Link("VAPI · Voice API", destination: URL(string: "https://vapi.ai")!)
                            .font(.body)
                            .foregroundColor(.white.opacity(0.8))
                        
                        Link("Daily · Calling API", destination: URL(string: "https://www.daily.co")!)
                            .font(.body)
                            .foregroundColor(.white.opacity(0.8))
                        
                        Link("Deepgram · Speech-to-Text API", destination: URL(string: "https://deepgram.com")!)
                            .font(.body)
                            .foregroundColor(.white.opacity(0.8))
                        
                        Link("OpenAI · Voice-to-Text API", destination: URL(string: "https://openai.com")!)
                            .font(.body)
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text("Your conversations are being routed through their servers. They are not private.")
                            .font(.footnote)
                            .foregroundColor(.white.opacity(0.6))
                        
                        Text("We never store personal information about you. However, the conversations are logged.")
                            .font(.footnote)
                            .foregroundColor(.white.opacity(0.6))
                        
                        Text("We will delete the logs on our end.")
                            .font(.footnote)
                            .foregroundColor(.white.opacity(0.6))
                    }
                Spacer()
                Spacer()


            }.padding()
            
            
        }
    }
}



extension AppSettingsView {
    
    private var SettingsCard: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                HStack {
                    VStack {
                        ZStack {
                            Circle()
                                .foregroundColor(.black.opacity(0.1))
                                .frame(width: 40, height: 40)
                            
                                Image(systemName: "heart.fill")
                                    .font(.system(size: 23))
                                    .foregroundColor(.black.opacity(0.6))
                                    .padding(6)
                                    .background(Color.clear)
                                    .clipShape(Circle())
                        }
                        Spacer()
                    }
                    Spacer()
                    Spacer()
                    
                }
                Spacer()
            }
        }
        .matchedGeometryEffect(id: "card", in: animation)
        .frame(width: UIScreen.main.bounds.width - 60, height: UIScreen.main.bounds.height / 3.7)
        .padding(.horizontal, 15)
        .padding(.vertical, 12)
        .background(Color.white)
        .cornerRadius(25)

    }

}

