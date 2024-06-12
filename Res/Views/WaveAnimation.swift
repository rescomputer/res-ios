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
    @Binding var isAssistantSpeaking: Bool
    @State private var waveOffset = Angle(degrees: 0)
        
    private let minFrequencyLevel = 0.033
    private let frequencyMultiplier = 60.0

    var frequency: Double {
        max(Double(audioLevel), minFrequencyLevel) * frequencyMultiplier
    }
    
    var waveHeight: Double {
        isAssistantSpeaking ? Double(height) : 0
    }

    var body: some View {
        ZStack {
            Wave(offset: waveOffset, waveHeight: waveHeight, frequency: frequency)
                .stroke(Color.green, lineWidth: 5)
                .blur(radius: 4)
            
            Wave(offset: waveOffset, waveHeight: waveHeight, frequency: frequency)
                .stroke(Color.green, lineWidth: 3)
        }
    }
}

private struct Wave: Shape {
    var offset: Angle
    var waveHeight: Double
    var frequency: Double
    
    var animatableData: Double {
        get { offset.degrees }
        set { offset = Angle(degrees: newValue) }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let actualWaveHeight = waveHeight * rect.height
        let yOffset = rect.height / 2
        let startAngle = offset
        let endAngle = startAngle + Angle(degrees: 360)

        path.move(to: CGPoint(x: 0, y: yOffset + actualWaveHeight * CGFloat(sin(offset.radians * frequency))))
        for angle in stride(from: startAngle.degrees, through: endAngle.degrees, by: 1) {
            let x = CGFloat((angle - startAngle.degrees) / 360) * rect.width
            path.addLine(to: CGPoint(x: x, y: yOffset + actualWaveHeight * CGFloat(sin(Angle(degrees: angle).radians * frequency))))
        }
        return path
    }
}

#Preview {
    WaveAnimation(
        height: .constant(0.15),
        audioLevel: .constant(0.1),
        isAssistantSpeaking: .constant(true)
    )
}
