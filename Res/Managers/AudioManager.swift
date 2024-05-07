//
//  AudioManager.swift
//  Res
//
//  Created by Steven Sarmiento on 5/6/24.
//

import AVFoundation
import SwiftUI

class AudioManager: ObservableObject {
    @Published var audioLevels: [CGFloat] = Array(repeating: 0, count: 40)
    var audioEngine = AVAudioEngine()

    func setupAudioMonitoring() {
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)

        // Remove existing tap if any
        inputNode.removeTap(onBus: 0)

        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] (buffer, when) in
            guard let self = self else { return }
            let level = self.calculateAudioLevel(buffer: buffer)
            DispatchQueue.main.async {
                if self.audioLevels.last != CGFloat(level) {
                   self.audioLevels.append(CGFloat(level))
                   if self.audioLevels.count > 40 {
                       self.audioLevels.removeFirst()
                   }
                }
            }
        }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            audioEngine.prepare()
            try audioEngine.start()
        } catch {
            print("Error starting audio engine: \(error)")
        }
    }

    private func calculateAudioLevel(buffer: AVAudioPCMBuffer) -> Float {
        guard let channelData = buffer.floatChannelData else {
            return 0.0
        }
        
        let channelDataValue = channelData.pointee
        let channelDataValues = stride(from: 0,
                                       to: Int(buffer.frameLength),
                                       by: buffer.stride).map { channelDataValue[$0] }
        let rms = sqrt(channelDataValues.map { $0 * $0 }.reduce(0, +) / Float(buffer.frameLength))
        
        let avgPower = 20 * log10(rms)
        let meterLevel = max(0, avgPower + 50) / 2 
        
        return meterLevel
    }

    func stopAudioMonitoring() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        resetAudioLevels()
    }

    func resetAudioLevels() {
        DispatchQueue.main.async {
            self.audioLevels = Array(repeating: 0, count: 40)  
        }
    }
}

