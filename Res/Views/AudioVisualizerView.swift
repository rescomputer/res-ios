//
//  AudioVisualizerView.swift
//  Res
//
//  Created by Steven Sarmiento on 4/5/24.
//

import SwiftUI

struct AudioVisualizerView: View {
    let barCount = 40
    @State private var barHeights: [CGFloat] = []

    private func randomBarHeight() -> CGFloat {
        CGFloat.random(in: 20...50)
    }

    var body: some View {
            ZStack{
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.black.opacity(0.05))
                    .frame(width: .infinity, height:100) 
        
                HStack(spacing: 2) {
                    ForEach(0..<barCount, id: \.self) { _ in
                        Rectangle()
                            .fill(Color.gray.opacity(0.5))
                            .frame(width: 5, height: barHeights.randomElement() ?? 5)
                            .cornerRadius(25) 
                            .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: barHeights)
                    }
                }                
            }
            .onAppear {
                 barHeights = Array(repeating: 0, count: barCount).map { _ in randomBarHeight() }
                withAnimation {
                    barHeights = barHeights.map { _ in randomBarHeight() }
                }
        }
    }
}

#Preview("Audio Visualizer View") {
    AudioVisualizerView()
}

