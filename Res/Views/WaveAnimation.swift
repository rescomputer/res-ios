//
//  WaveAnimation.swift
//  Res
//
//  Created by Daniel Berezhnoy on 5/22/24.
//

import SwiftUI

struct WaveAnimation: View {
    @State private var waveOffset = Angle(degrees: 0)
    
    var body: some View {
        Wave(offset: waveOffset, percent: 50)
            .fill(Color.blue)
            .ignoresSafeArea(.all)
            .onAppear { startAnimation() }
    }
    
    private func startAnimation() {
        withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
            waveOffset = Angle(degrees: -360)
        }
    }
}

struct Wave: Shape {
    
    var offset: Angle
    var percent: Double
    
    var animatableData: Double {
        get { offset.degrees }
        set { offset = Angle(degrees: newValue) }
    }
    
    func path(in rect: CGRect) -> Path {
        var p = Path()
        
        let lowestWave = 0.02
        let highestWave = 1.00
        
        let newPercent = lowestWave + (highestWave - lowestWave) * (percent / 100)
        let waveHeight = 0.015 * rect.height
        let yOffSet = CGFloat(1 - newPercent) * (rect.height - 4 * waveHeight) + 2 * waveHeight
        let startAngle = offset
        let endAngle = offset + Angle(degrees: 360 + 10)
        
        p.move(to: CGPoint(x: 0, y: yOffSet + waveHeight * CGFloat(sin(offset.radians))))
        
        for angle in stride(from: startAngle.degrees, through: endAngle.degrees, by: 5) {
            let x = CGFloat((angle - startAngle.degrees) / 360) * rect.width
            p.addLine(to: CGPoint(x: x, y: yOffSet + waveHeight * CGFloat(sin(Angle(degrees: angle).radians))))
        }
        
        p.addLine(to: CGPoint(x: rect.width, y: rect.height))
        p.addLine(to: CGPoint(x: 0, y: rect.height))
        p.closeSubpath()
        
        return p
    }
}

#Preview {
    WaveAnimation()
}
