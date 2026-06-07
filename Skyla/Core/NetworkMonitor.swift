//
//  NetworkMonitor.swift
//  Skyla
//
//  Created by Shahudaa on 29/05/2026.
//


import Network
import Foundation
import Combine

final class NetworkMonitor: ObservableObject {

    static let shared = NetworkMonitor()

    private let monitor = NWPathMonitor()

    private let queue = DispatchQueue(label: "NetworkMonitor")

    @Published var isConnected = true

    private init() {

        monitor.pathUpdateHandler = { path in

            DispatchQueue.main.async {

                self.isConnected = path.status == .satisfied
            }
        }

        monitor.start(queue: queue)
    }
}
