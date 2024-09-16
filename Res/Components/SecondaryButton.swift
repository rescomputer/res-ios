//
//  SecondaryButton.swift
//  Res
//
//  Created by Steven Sarmiento on 9/15/24.
//

import SwiftUI

struct SecondaryButton: View {
    var title: String
    var action: () -> Void

    var body: some View {
        Button(action: {
            action()
        }) {
            Text(title)
                .font(.system(size: 18, weight: .regular, design: .rounded))
                .foregroundColor(Color(red: 0.224, green: 0.216, blue: 0.161))
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color(red: 0.973, green: 0.973, blue: 0.949), Color(red: 0.953, green: 0.953, blue: 0.914)]), startPoint: .top, endPoint: .bottom)
                        .cornerRadius(40)
                       // .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 40)
                        .stroke(Color.black.opacity(0.2), lineWidth: 1)
                        .blur(radius: 1)
                        .offset(x: 0, y: 1)
                        .mask(RoundedRectangle(cornerRadius: 40).fill(LinearGradient(gradient: Gradient(colors: [Color.black, Color.clear]), startPoint: .top, endPoint: .bottom)))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 40)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        .blur(radius: 1)
                        .offset(x: 0, y: -1)
                        .mask(RoundedRectangle(cornerRadius: 40).fill(LinearGradient(gradient: Gradient(colors: [Color.clear, Color.white]), startPoint: .top, endPoint: .bottom)))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 40, style: .continuous)
                        .strokeBorder(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.5),
                                    Color.white.opacity(0),
                                    Color.black.opacity(0.5)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: 1
                        )
                        .blendMode(.overlay)
                        .blur(radius: 1.0)
                )
        }
    }
}

struct SecondaryButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SecondaryButton(title: "Cancel", action: { print("Cancel action") })
            SecondaryButton(title: "Confirm", action: { print("Confirm action") })
        }
        .padding()
    }
}