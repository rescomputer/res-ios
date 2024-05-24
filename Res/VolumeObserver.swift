//
//  File.swift
//  Res
//
//  Created by Daniel Berezhnoy on 5/24/24.
//

import SwiftUI
import MediaPlayer
import AVFoundation

class VolumeObserver: ObservableObject {
    @Published var volume: Float = AVAudioSession.sharedInstance().outputVolume

    private var volumeView: MPVolumeView!
    private var observation: NSKeyValueObservation?

    init() {
        setupVolumeView()
        observeVolumeChanges()
    }

    private func setupVolumeView() {
        volumeView = MPVolumeView(frame: .zero)
        volumeView.isHidden = true
        if let window = UIApplication.shared.windows.first {
            window.addSubview(volumeView)
        }
    }

    private func observeVolumeChanges() {
        observation = AVAudioSession.sharedInstance().observe(\.outputVolume, options: [.new]) { [weak self] _, change in
            if let newVolume = change.newValue {
                DispatchQueue.main.async {
                    self?.volume = newVolume
                }
            }
        }
    }

    deinit {
        observation?.invalidate()
    }
}

struct ContentView: View {
    @StateObject private var volumeObserver = VolumeObserver()

    var body: some View {
        VStack {
            Text("Current Volume: \(volumeObserver.volume)")
                .padding()
            // Your other UI components
        }
    }
}

#Preview {
    ContentView()
}
