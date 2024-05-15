//
//  AudioManager.swift
//  Res
//
//  Created by Daniel Berezhnoy on 5/14/24.
//

import AVFoundation

@MainActor class AudioManager: ObservableObject {
    var audioPlayer: AVAudioPlayer?
    
    func playDialUpSound() {
        guard let path = Bundle.main.path(forResource: "dial.up.sound", ofType: "mp3") else {
            return
        }
        
        let url = URL(fileURLWithPath: path)

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func stopPlaying() {
        audioPlayer?.stop()
    }
}
