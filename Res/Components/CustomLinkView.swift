//
//  CustomLinkView.swift
//  Res
//
//  Created by Steven Sarmiento on 3/23/24.
//


import Foundation
import SwiftUI

struct CustomToggle: View {
    let title: String
    let systemImageName: String

    @Binding var isOn: Bool

    var body: some View {
        HStack {
            Image(systemName: systemImageName)
                .font(.system(size: 16))
                .bold()
                .foregroundColor(.white.opacity(0.3))
                .frame(width: 30, height: 30)
        
             Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .bold()
            Spacer()
            Toggle("", isOn: $isOn)
                .toggleStyle(SwitchToggleStyle(tint: .green.opacity(1)))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(Color(red: 0.063, green: 0.106, blue: 0.106))
        )
    }
}

struct CustomLinkView: View {
    var iconName: String
    var title: String
    var action: () -> Void
    var navigateTo: () -> Void
    var screenSize: CGSize
    var offset: CGFloat
    var minHeight: CGFloat

    var progress: Double {
        let total = Double(screenSize.height - minHeight)
        let current = Double(offset)
        return current / total
    }
    

    var body: some View {
        Button(action: {
            self.navigateTo()
        }) {
            HStack {
                Image(systemName: iconName)
                    .font(.system(size: 16))
                    .bold()
                    .foregroundColor(.white.opacity(0.3))
                    .frame(width: 30, height: 30)
                 
                Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .bold()
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 16))
                    .bold()
                    .foregroundColor(.white.opacity(0.3))
                    .frame(width: 30, height: 30)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                .foregroundColor(Color(red: 0.063, green: 0.106, blue: 0.106))
            )
        }
        .pressAnimation()
    }
}

#Preview("Custom Link View") {
    CustomLinkView(
        iconName: "link.circle",
        title: "Navigate to Example",
        action: {},
        navigateTo: {},
        screenSize: UIScreen.main.bounds.size,
        offset: 0,
        minHeight: 100
    )
}
