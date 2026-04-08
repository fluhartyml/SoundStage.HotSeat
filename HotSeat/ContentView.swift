//
//  ContentView.swift
//  HotSeat
//
//  Created by Michael Fluharty on 4/8/26.
//

import SwiftUI

struct ContentView: View {
    @Environment(CaptureManager.self) var captureManager
    @Environment(PeerAdvertiser.self) var peerAdvertiser

    var body: some View {
        @Bindable var cm = captureManager
        NavigationStack {
            GeometryReader { geo in
                VStack(spacing: 0) {
                    // MARK: - Video Preview (top 55%)
                    ZStack {
                        VideoPreviewView(session: captureManager.captureSession)
                            .background(.black)

                        if captureManager.isRecording {
                            VStack {
                                HStack {
                                    HStack(spacing: 6) {
                                        Circle()
                                            .fill(.red)
                                            .frame(width: 12, height: 12)
                                        Text(captureManager.formattedDuration())
                                            .font(.system(size: 20, weight: .bold, design: .monospaced))
                                            .foregroundStyle(.white)
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(.black.opacity(0.6))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    Spacer()
                                }
                                .padding()
                                Spacer()
                            }
                        }

                        if !captureManager.hasExternalVideo {
                            VStack(spacing: 12) {
                                Image(systemName: "video.slash")
                                    .font(.system(size: 48))
                                    .foregroundStyle(.secondary)
                                Text("No Video Source")
                                    .font(.system(size: 22, weight: .medium))
                                    .foregroundStyle(.secondary)
                                Text("Connect an Elgato or camera")
                                    .font(.system(size: 18))
                                    .foregroundStyle(.tertiary)
                            }
                        }
                    }
                    .frame(height: geo.size.height * 0.55)

                    // MARK: - Controls (bottom 45%)
                    ScrollView {
                        VStack(spacing: 16) {
                            transportControls
                            levelMeters
                            inputLabels
                            markerControls
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Hot Seat")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        HotSeatSettingsView()
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(peerAdvertiser.isConnectedToProducer ? .green : .secondary)
                            .frame(width: 8, height: 8)
                        Text(peerAdvertiser.isConnectedToProducer ? "Producer" : "Solo")
                            .font(.system(size: 14))
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }

    // MARK: - Transport Controls

    private var transportControls: some View {
        HStack(spacing: 20) {
            Button {
                if captureManager.isRecording {
                    captureManager.stopRecording()
                } else {
                    captureManager.startRecording()
                }
            } label: {
                Image(systemName: captureManager.isRecording ? "stop.circle.fill" : "record.circle")
                    .font(.system(size: 44))
                    .foregroundStyle(captureManager.isRecording ? Color.primary : Color.red)
            }

            Button {
                if captureManager.isPaused {
                    captureManager.resumeRecording()
                } else {
                    captureManager.pauseRecording()
                }
            } label: {
                Image(systemName: captureManager.isPaused ? "play.circle" : "pause.circle")
                    .font(.system(size: 44))
                    .foregroundStyle(.primary)
            }
            .disabled(!captureManager.isRecording)
            .opacity(captureManager.isRecording ? 1 : 0.3)

            Spacer()

            if captureManager.isRecording {
                Text(captureManager.formattedDuration())
                    .font(.system(size: 24, weight: .medium, design: .monospaced))
                    .foregroundStyle(captureManager.isPaused ? .orange : .red)
            }
        }
    }

    // MARK: - Level Meters

    private var levelMeters: some View {
        @Bindable var cm = captureManager
        return VStack(spacing: 8) {
            HStack {
                Text("MIC")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.secondary)
                    .frame(width: 50, alignment: .leading)
                LevelMeterBar(level: captureManager.micLevel, threshold: captureManager.squelchThreshold)
                Slider(value: $cm.micVolume, in: 0...1)
                    .frame(width: 80)
            }
            HStack {
                Text("INPUT")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.secondary)
                    .frame(width: 50, alignment: .leading)
                LevelMeterBar(level: captureManager.inputLevel, threshold: nil)
                Slider(value: $cm.inputVolume, in: 0...1)
                    .frame(width: 80)
            }
        }
    }

    // MARK: - Input Labels

    private var inputLabels: some View {
        HStack(spacing: 16) {
            Label(captureManager.selectedVideoName, systemImage: "video")
                .font(.system(size: 16))
                .foregroundStyle(.secondary)
            Spacer()
            Label(captureManager.selectedAudioName, systemImage: "waveform")
                .font(.system(size: 16))
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Marker Controls

    private var markerControls: some View {
        HStack(spacing: 12) {
            Button {
            } label: {
                Label("PTT", systemImage: "mic")
                    .font(.system(size: 18, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(.green.opacity(0.15))
                    .foregroundStyle(.green)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }

            Button {
            } label: {
                Label("Transition", systemImage: "arrow.triangle.swap")
                    .font(.system(size: 18))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(.blue.opacity(0.15))
                    .foregroundStyle(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }

            Menu {
                Button("A") {}
                Button("B") {}
                Button("C") {}
                Button("D") {}
            } label: {
                Label("Notes", systemImage: "note.text")
                    .font(.system(size: 18))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(.orange.opacity(0.15))
                    .foregroundStyle(.orange)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }
}

// MARK: - Level Meter Bar

struct LevelMeterBar: View {
    let level: Double
    let threshold: Double?

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(.secondary.opacity(0.2))
                RoundedRectangle(cornerRadius: 4)
                    .fill(levelColor)
                    .frame(width: geo.size.width * CGFloat(min(level, 1.0)))
                if let threshold {
                    Rectangle()
                        .fill(.white.opacity(0.6))
                        .frame(width: 2)
                        .offset(x: geo.size.width * CGFloat(threshold))
                }
            }
        }
        .frame(height: 12)
    }

    private var levelColor: Color {
        if level > 0.8 { return .red }
        if level > 0.6 { return .orange }
        return .green
    }
}

#Preview {
    ContentView()
        .environment(CaptureManager())
        .environment(PeerAdvertiser())
}
