//
//  Loader.swift
//  Her
//
//  Created by Steven Sarmiento on 4/7/24.
//

import SwiftUI

struct Loader : View {
    @State var animate = false

    var body: some View {
        ZStack {
            Circle()
                .stroke(AngularGradient(gradient: .init(colors: [.black.opacity(0.077), .black.opacity(0.077)]),
                                        center:.center), style: StrokeStyle(lineWidth: 4))
            Circle()
                .trim(from:0, to: 0.6)
                .stroke(AngularGradient(gradient: .init(colors: [Color(red: 1, green: 0.596, blue: 0.486), Color(red: 1, green: 0.596, blue: 0.486)]),
                                        center:.center), style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .rotationEffect(.init(degrees: self.animate ? 720 : 0))
                .animation(Animation.easeIn(duration: 0.6).repeatForever(autoreverses: false), value: animate)
        }
        .onAppear {
            self.animate = true
        }
    }
}
    
