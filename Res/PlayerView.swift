//
//  PlayerView.swift
//  Res
//
//  Created by Daniel Berezhnoy on 5/14/24.
//

import SwiftUI

struct PlayerView: View {
    @StateObject private var audioManager = AudioManager()
    
    var body: some View {
        Button {
            audioManager.playSound()
        } label: {
            Image(systemName: "play.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
        }
    }
}

#Preview {
    PlayerView()
}
