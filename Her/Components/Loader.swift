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
        VStack {
            Circle()
                .trim(from:0, to: 0.8)
                .stroke(AngularGradient(gradient: .init(colors: [.clear, .white.opacity(1)]),
                                        center:.center), style: StrokeStyle(lineWidth: 8))
                .rotationEffect(.init(degrees: self.animate ? 720 : 0))
                .animation(Animation.easeIn(duration: 0.6).repeatForever(autoreverses: false), value: animate)
        }
        .onAppear {
            self.animate = true
        }
    }
}
    
