//
//  AppIconView.swift
//  Res
//
//  Created by Steven Sarmiento on 9/16/24.
//

import SwiftUI

struct AppIconView: View {
    @Binding var isActive: Bool

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8, blendDuration: 0)) {
                        isActive = false
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
                Spacer()
                Text("App Icon")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(Color(red: 0.271, green: 0.267, blue: 0.2))
                Spacer()
                Button(action: {
                    // feedback flow
                }) {
                    HStack {
                        Image(systemName: "heart")
                        // Text("RES")
                    }
                    .foregroundColor(.orange)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                }
            }
            .padding()

            Spacer()
            Text("App icon selection content goes here")
            Spacer()
        }
        .background(Color(red: 0.945, green: 0.945, blue: 0.918))
    }
}