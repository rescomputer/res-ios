//
//  AudioRecorder.swift
//  Her
//
//  Created by Lyndon Leong on 19/04/2024.
//

import Foundation
import Combine
import AVFoundation



class AudioRecorder: ObservableObject {
    @Published var isRecording: Bool = false
    @Published var amplitude: Float = 1.0
    
    private let audioEngine = AVAudioEngine()
    private var audioInputNode: AVAudioInputNode?
    
    private var audioFormat: AVAudioFormat?
    private var minAmplitude: Float = Float.greatestFiniteMagnitude
    private var maxAmplitude: Float = -Float.greatestFiniteMagnitude

    init() {
        setupAudioSession()
    }

    private func setupAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }


    private func updateAudioLevel(buffer: AVAudioPCMBuffer) {
        guard let channelData = buffer.floatChannelData?.pointee else {
            return
        }
        // do some funky maths
        let channelDataValues = stride(from: 0, to: Int(buffer.frameLength * buffer.format.channelCount), by: buffer.stride).map { channelData[$0] }
        let rmsValue = sqrt(channelDataValues.map { $0 * $0 }.reduce(0, +) / Float(buffer.frameLength * buffer.format.channelCount))
        minAmplitude = min(minAmplitude, rmsValue)
        maxAmplitude = max(maxAmplitude, rmsValue)
        let normalizedAmplitude = (rmsValue - minAmplitude) / (maxAmplitude - minAmplitude)
        DispatchQueue.main.async { [weak self] in
            self?.amplitude = normalizedAmplitude
        }
    }
    
    
    func startRecording() {
        guard !isRecording else {
            print("Already recording")
            return
        }
        
        // Reset amplitude range
        minAmplitude = Float.greatestFiniteMagnitude
        maxAmplitude = -Float.greatestFiniteMagnitude
        
 
        
        // Configure audio settings for recording
        let inputAudioSettings: [String: Any] = [
            AVFormatIDKey: kAudioFormatLinearPCM,
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        
        // Initialize audio engine
        audioInputNode = audioEngine.inputNode
        audioFormat = audioInputNode?.outputFormat(forBus: 0)
        
        // Input node tap
        let installedInputTap: Void? = audioInputNode?.installTap(onBus: 0, bufferSize: 1024, format: audioFormat, block: { buffer, _ in
            self.updateAudioLevel(buffer: buffer)
        })
        if installedInputTap == nil {
            print("Failed to install tap on audio input node")
        }
    
        do {
            // Prepare and start the audio engine
            audioEngine.prepare()
            try audioEngine.start()
            
            // Set recording flag
            isRecording = true
        } catch {
            print("Failed to start recording: \(error)")
        }
    }


    func stopRecording() {
        guard isRecording else {
            return
        }
        
        audioEngine.stop()
        audioInputNode?.removeTap(onBus: 0)
        
        isRecording = false
     
    }
}

