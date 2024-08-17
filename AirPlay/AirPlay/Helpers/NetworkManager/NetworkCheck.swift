//
//  NetworkCheck.swift
//  AirPlay
//
//  Created by Aj on 17/08/24.
//

import Foundation
import Network

class NetworkCheck {
    
    static let shared = NetworkCheck()
    private let monitor: NWPathMonitor
    private let queue = DispatchQueue.global(qos: .background)
    
    private init() {
        monitor = NWPathMonitor()
        setupPathUpdateHandler()
    }
    
    var isConnected: Bool {
        return monitor.currentPath.status == .satisfied
    }
    
    private func setupPathUpdateHandler() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard self != nil else { return }
            let isConnected = path.status == .satisfied
            NotificationCenter.default.post(name: .networkStatusChanged, object: nil, userInfo: ["isConnected": isConnected])
        }
        monitor.start(queue: queue)
    }
    
    func startMonitoring() {
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}

extension Notification.Name {
    static let networkStatusChanged = Notification.Name("networkStatusChanged")
}
