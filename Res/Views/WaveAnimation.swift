//
//  WaveAnimation.swift
//  Res
//
//  Created by Daniel Berezhnoy on 5/22/24.
//

import SwiftUI

struct WaveAnimation: View {
    
    @Binding var height: Float
    @Binding var audioLevel: Float
    @Binding var levelStable: Bool
    @Binding var isAssistantSpeaking: Bool
    @State private var waveOffset = Angle(degrees: 0)
        
    var frequency: Double {
        audioLevel < 0.05 ? 2 : Double(audioLevel * 60)
    }
    
    var waveHeight: Double {
        isAssistantSpeaking ? Double(height) : 0
    }
    

    var body: some View {
        ZStack {
            Wave(offset: waveOffset, waveHeight: waveHeight, frequency: frequency) // Adjust frequency here
                .stroke(.green, lineWidth: 5)
//                .onAppear { startAnimation() }
                .blur(radius: 4)
            
            Wave(offset: waveOffset, waveHeight: waveHeight, frequency: frequency) // Adjust frequency here
                .stroke(.green, lineWidth: 3)
//                .onAppear { startAnimation() }
        }
    }
    
    private func startAnimation() {
        withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
            waveOffset = Angle(degrees: -360)
        }
    }
    
//    private var waveHeight: Double {
//        if height > 0.0000001 && height < 0.00001 {
//            return 0.01
//        } else if height > 0.00001 && height < 0.9 {
//            return 0.1
//        } else if height > 0.9 && height < 10 {
//            return 0.2
//        } else {
//            return 0
//        }
//    }
}
 
private struct Wave: Shape {
    
    var offset: Angle
    let waveHeight: Double
    let frequency: Double // New frequency property
    
    var animatableData: Double {
        get { offset.degrees }
        set { offset = Angle(degrees: newValue) }
    }
    
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let actualWaveHeight = waveHeight * rect.height
        let yOffSet = rect.height / 2
        let startAngle = offset
        let endAngle = offset + Angle(degrees: 360 + 10)
        
        p.move(to: CGPoint(x: 0, y: yOffSet + actualWaveHeight * CGFloat(sin(offset.radians * frequency)))) // Apply frequency
        
        for angle in stride(from: startAngle.degrees, through: endAngle.degrees, by: 5) {
            let x = CGFloat((angle - startAngle.degrees) / 360) * rect.width
            p.addLine(to: CGPoint(x: x, y: yOffSet + actualWaveHeight * CGFloat(sin(Angle(degrees: angle).radians * frequency)))) // Apply frequency
        }
        
        return p
    }
    
//    init(offset: Angle, waveHeight: Double, frequency: Double) {
//        self.offset = offset
//        self.waveHeight = waveHeight
//        self.frequency = frequency
//    }
}

#Preview {
    WaveAnimation(
        height: .constant(0.15),
        audioLevel: .constant(0.1),
        levelStable: .constant(false),
        isAssistantSpeaking: .constant(true)
    )
}
