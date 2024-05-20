//
//  AudioVisualizationView.swift
//  Her
//
//  Created by Steven Sarmiento on 3/24/24.
//

import SwiftUI

struct AudioVisualizationView: View {
    var userAudioLevels: [CGFloat]
    var aiAudioLevels: [CGFloat]

    var body: some View {
        VStack {
            // User audio visualization
            audioVisualization(for: userAudioLevels, color: .blue)
            // AI audio visualization
            //audioVisualization(for: aiAudioLevels, color: .green)
        }
    }

    private func audioVisualization(for levels: [CGFloat], color: Color) -> some View {
        GeometryReader { geometry in
            HStack(spacing: 4) {
                ForEach(levels, id: \.self) { level in
                    RoundedRectangle(cornerRadius: 2)
                        .frame(width: (geometry.size.width - CGFloat(levels.count * 4)) / CGFloat(levels.count), height: level)
                        .foregroundColor(color)
                }
            }
        }
    }
}
