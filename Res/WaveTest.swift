//
//  WaveTest.swift
//  Res
//
//  Created by Daniel Berezhnoy on 5/24/24.
//

import SwiftUI

struct WaveTest: View {
    @State private var volume: Float = 0
    
    var body: some View {
        VStack {
            Text("\(volume)")
            
            WaveAnimation(height: $volume, levelStable: .constant(false))
            
            Slider(value: $volume, in: 0...0.1)
                .tint(.green)
                .padding()
        }
    }
}

#Preview {
    WaveTest()
}
