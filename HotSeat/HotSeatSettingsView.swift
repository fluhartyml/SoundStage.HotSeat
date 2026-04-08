//
//  HotSeatSettingsView.swift
//  HotSeat
//
//  Local settings for Hot Seat — squelch, export, device preferences.
//

import SwiftUI

struct HotSeatSettingsView: View {
    @Environment(CaptureManager.self) var captureManager
    @Environment(PeerAdvertiser.self) var peerAdvertiser

    @AppStorage("exportFormat") private var exportFormat = "mov"
    @AppStorage("videoResolution") private var videoResolution = "1080p"
    @AppStorage("saveDestination") private var saveDestination = "documents"

    var body: some View {
        @Bindable var cm = captureManager
        Form {
            Section("Audio") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Squelch Threshold: \(captureManager.squelchThreshold, specifier: "%.2f")")
                        .font(.system(size: 18))
                    Slider(value: $cm.squelchThreshold, in: 0.05...0.80, step: 0.01)
                }
            }

            Section("Export") {
                Picker("Format", selection: $exportFormat) {
                    Text("MOV").tag("mov")
                    Text("MP4").tag("mp4")
                    Text("WAV (audio only)").tag("wav")
                    Text("AAC (audio only)").tag("aac")
                }
                .font(.system(size: 18))

                Picker("Resolution", selection: $videoResolution) {
                    Text("720p").tag("720p")
                    Text("1080p").tag("1080p")
                    Text("4K").tag("4K")
                }
                .font(.system(size: 18))
            }

            Section("Save To") {
                Picker("Destination", selection: $saveDestination) {
                    Text("App Documents").tag("documents")
                    Text("Photos Library").tag("photos")
                    Text("Custom Folder").tag("custom")
                }
                .font(.system(size: 18))
            }

            Section("Network") {
                HStack {
                    Text("Producer Connection")
                        .font(.system(size: 18))
                    Spacer()
                    if peerAdvertiser.isConnectedToProducer {
                        Label("Connected", systemImage: "checkmark.circle.fill")
                            .font(.system(size: 18))
                            .foregroundStyle(.green)
                    } else {
                        Text("Not Connected")
                            .font(.system(size: 18))
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Section("About") {
                HStack {
                    Text("Version").font(.system(size: 18))
                    Spacer()
                    Text("0.1").font(.system(size: 18)).foregroundStyle(.secondary)
                }
                HStack {
                    Text("Developer").font(.system(size: 18))
                    Spacer()
                    Text("Michael Lee Fluharty").font(.system(size: 18)).foregroundStyle(.secondary)
                }
                HStack {
                    Text("Engineered with").font(.system(size: 18))
                    Spacer()
                    Text("Claude by Anthropic").font(.system(size: 18)).foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationStack {
        HotSeatSettingsView()
            .environment(CaptureManager())
            .environment(PeerAdvertiser())
    }
}
