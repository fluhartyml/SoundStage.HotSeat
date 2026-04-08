//
//  HotSeatApp.swift
//  HotSeat
//
//  Created by Michael Fluharty on 4/8/26.
//

import SwiftUI

@main
struct HotSeatApp: App {
    @State private var captureManager = CaptureManager()
    @State private var peerAdvertiser = PeerAdvertiser()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(captureManager)
                .environment(peerAdvertiser)
        }
    }
}
