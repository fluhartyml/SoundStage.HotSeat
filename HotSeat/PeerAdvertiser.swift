//
//  PeerAdvertiser.swift
//  HotSeat
//
//  Advertises Hot Seat on the network so Producer can discover and control it.
//  Networking will be wired in after UI is validated.
//

import Foundation

@MainActor
@Observable
class PeerAdvertiser {
    var isAdvertising = false
    var isConnectedToProducer = false

    func startAdvertising() {
        isAdvertising = true
    }

    func stopAdvertising() {
        isAdvertising = false
    }
}
