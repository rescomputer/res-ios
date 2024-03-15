//
//  VideoPlayerView.swift
//  Her
//
//  Created by Daniel Berezhnoy on 3/15/24.
//

import SwiftUI
import AVFoundation

struct VideoPlayerView: UIViewRepresentable {
    var videoURL: URL
    
    func makeUIView(context: Context) -> UIView {
        let containerView = UIView(frame: .zero)
        
        // Initialize AVPlayer
        let player = AVPlayer(url: videoURL)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = containerView.bounds
        playerLayer.videoGravity = .resizeAspectFill
        containerView.layer.addSublayer(playerLayer)
        
        // Loop the video
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
            player.seek(to: .zero)
            player.play()
        }
        
        player.play() // Automatically play video
        
        return containerView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Update the view when needed
    }
}
