//
//  CaptureManager.swift
//  HotSeat
//
//  Manages video and audio capture from external devices (Elgato 4K S)
//  and built-in mic. UI wireframe first, hardware wiring after.
//

import Foundation
import AVFoundation

@MainActor
@Observable
class CaptureManager {
    // MARK: - State

    var isRecording = false
    var isPaused = false
    var recordingDuration: TimeInterval = 0
    var micLevel: Double = 0
    var inputLevel: Double = 0
    var hasExternalVideo = false
    var hasExternalAudio = false
    var selectedVideoName = "No Video"
    var selectedAudioName = "No Audio"
    var selectedMicName = "Built-in Mic"
    var squelchThreshold: Double = 0.15
    var micVolume: Double = 1.0
    var inputVolume: Double = 1.0

    let captureSession = AVCaptureSession()

    private var durationTimer: Timer?
    private var recordingStartTime: Date?

    // MARK: - Recording (stubbed for UI testing)

    func startRecording() {
        isRecording = true
        isPaused = false
        recordingStartTime = Date()
        durationTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self, let start = self.recordingStartTime else { return }
            Task { @MainActor in
                self.recordingDuration = Date().timeIntervalSince(start)
            }
        }
    }

    func stopRecording() {
        isRecording = false
        isPaused = false
        durationTimer?.invalidate()
        durationTimer = nil
        recordingDuration = 0
    }

    func pauseRecording() {
        guard isRecording, !isPaused else { return }
        isPaused = true
    }

    func resumeRecording() {
        guard isRecording, isPaused else { return }
        isPaused = false
    }

    func formattedDuration() -> String {
        let hours = Int(recordingDuration) / 3600
        let minutes = (Int(recordingDuration) % 3600) / 60
        let seconds = Int(recordingDuration) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
