//
//  AudioVisualizerView.swift
//  Her
//
//  Created by Steven Sarmiento on 4/5/24.
//

import SwiftUI

struct AudioVisualizerView: View {
    let barCount = 20
    @State private var barHeights: [CGFloat] = []
    @ObservedObject var audioRecorder: AudioRecorder
    
    private let defaultBarHeight: CGFloat = 20 // Set a default height for the bars

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black.opacity(0.05))
                .frame(width: .infinity, height: 100)
            
            HStack(spacing: 2) {
                ForEach(0..<barCount, id: \.self) { _ in
                    Rectangle()
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 5, height: self.barHeights.randomElement() ?? self.defaultBarHeight)
                        .cornerRadius(25)
                }
            }
        }
        .onAppear {
            self.barHeights = Array(repeating: 0, count: self.barCount)
        }
        .onReceive(audioRecorder.$amplitude) { amplitude in
            self.updateBarHeights(for: amplitude)
        }
    }
    
    private func updateBarHeights(for amplitude: Float) {
        let scaledAmplitude = CGFloat(amplitude) * 50 // Scale the amplitude as needed
        let clampedHeight = max(scaledAmplitude, 10) // Ensure a minimum height for visibility

        // Check if the array already has the desired number of bars, remove the first if it does
        if self.barHeights.count >= self.barCount {
            self.barHeights.removeFirst()
        }
        
        // Add the new amplitude to the end of the array
        self.barHeights.append(clampedHeight)
    }}
