//
//  WaveformView.swift
//  Res
//
//  Created by Steven Sarmiento on 5/6/24.
//

import Foundation
import SwiftUI

struct WaveformView: View {
    @Binding var audioLevels: [CGFloat]
    @Binding var isRecording: Bool
    @State private var orbScale: CGFloat = 1

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                CentralWaveformView(audioLevels: $audioLevels, isRecording: $isRecording)
            }
        }
    }
}

struct CentralWaveformView: View {
    @Binding var audioLevels: [CGFloat]
    @Binding var isRecording: Bool

    var body: some View {
        GeometryReader { geometry in
        ZStack {
            waveformPath(audioLevels: audioLevels, centerY: geometry.size.height / 2, tapeGap: 5, lineWidth: 5, opacity: 0.1)  
            waveformPath(audioLevels: audioLevels, centerY: geometry.size.height / 2, tapeGap: 5, lineWidth: 3, opacity: 0.3)  
            waveformPath(audioLevels: audioLevels, centerY: geometry.size.height / 2, tapeGap: 5, lineWidth: 1, opacity: 1)  
        }
        }
    }
    
    func waveformPath(audioLevels: [CGFloat], centerY: CGFloat, tapeGap: CGFloat, lineWidth: CGFloat, opacity: Double) -> some View {
        GeometryReader { geometry in
            Path { path in
                let width = geometry.size.width / CGFloat(audioLevels.count)

                for (index, level) in audioLevels.enumerated() {
                    let x = CGFloat(index) * width
                    let y1 = centerY - level * tapeGap
                    let y2 = centerY + level * tapeGap

                    if index == 0 {
                        path.move(to: CGPoint(x: x, y: y1))
                    } else {
                        path.addCurve(
                            to: CGPoint(x: x, y: y1),
                            control1: CGPoint(x: x - width / 2, y: path.currentPoint!.y),
                            control2: CGPoint(x: x - width / 2, y: y1)
                        )
                    }
                    path.addCurve(
                        to: CGPoint(x: x, y: y2),
                        control1: CGPoint(x: x, y: centerY),
                        control2: CGPoint(x: x, y: centerY)
                    )
                }
            }
            .stroke(isRecording ? Color.green.opacity(opacity) : Color.orange.opacity(opacity), lineWidth: lineWidth)
            .mask(
                RadialGradient(
                    gradient: Gradient(colors: [.white, .clear]),
                    center: .center,
                    startRadius: 0,
                    endRadius: min(geometry.size.width, geometry.size.height) / 2
                )
            )
        }
    }
}
