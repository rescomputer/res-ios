//
//  WaveAnimation.swift
//  Res
//
//  Created by Daniel Berezhnoy on 5/22/24.
//

import SwiftUI

struct WaveAnimation: View {
    
    @Binding var height: Float
    @State private var waveOffset = Angle(degrees: 0)
    
    var body: some View {
        Wave(offset: waveOffset, waveHeight: Double(height) / 100)
            .stroke(Color.green, lineWidth: 3.5)
            .onAppear { startAnimation() }
    }
    
    private func startAnimation() {
//        withAnimation(.linear(duration: 1 - height / 100).repeatForever(autoreverses: false)) {
        withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
            waveOffset = Angle(degrees: -360)
        }
    }
}

private struct Wave: Shape {
    
    var offset: Angle
    let waveHeight: Double
    
    // Animatable data for the shape
    var animatableData: Double {
        get { offset.degrees }
        set { offset = Angle(degrees: newValue) }
    }
    
    func path(in rect: CGRect) -> Path {
        // Initialize a new Path object
        var p = Path()
        
        // Define the wave height as a small fraction of the view's height
        let actualWaveHeight = waveHeight * rect.height
        
        // Set a fixed vertical position for the thin wave line
        let yOffSet = rect.height / 2
        
        // Define the start and end angles for the wave animation
        let startAngle = offset
        let endAngle = offset + Angle(degrees: 360 + 10)
        
        // Move to the initial point of the wave on the left side of the view
        p.move(to: CGPoint(x: 0, y: yOffSet + actualWaveHeight * CGFloat(sin(offset.radians))))
        
        // Iterate over the angles to draw the wave pattern
        for angle in stride(from: startAngle.degrees, through: endAngle.degrees, by: 5) {
            
            // Calculate the x-coordinate based on the current angle
            let x = CGFloat((angle - startAngle.degrees) / 360) * rect.width
            
            // Add a line to the current point of the wave,
            // adjusting y-coordinate based on sine function
            p.addLine(to: CGPoint(x: x, y: yOffSet + actualWaveHeight
                                  * CGFloat(sin(Angle(degrees: angle).radians))))
        }
        
        return p // Return the constructed path representing the wave shape
    }
    
    init(offset: Angle, waveHeight: Double = 0.015) {
        self.offset = offset
        self.waveHeight = waveHeight
    }
}

#Preview {
    WaveAnimation(height: .constant(2))
}
