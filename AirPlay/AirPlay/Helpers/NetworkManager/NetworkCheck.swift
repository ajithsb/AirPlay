//
//  NetworkCheck.swift
//  AirPlay
//
//  Created by Aj on 17/08/24.
//

import Foundation
import Network

@objc class NetworkCheck: NSObject {
    
    @objc static let shared = NetworkCheck()
    private let monitor: NWPathMonitor
    private let queue = DispatchQueue.global(qos: .background)
    
    private override init() {
        monitor = NWPathMonitor()
        super.init()
        setupPathUpdateHandler()
    }
    
    @objc var isConnected: Bool {
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
    
    @objc func startMonitoring() {
        monitor.start(queue: queue)
    }
    
    @objc func stopMonitoring() {
        monitor.cancel()
    }
}

extension Notification.Name {
    static let networkStatusChanged = Notification.Name("networkStatusChanged")
}
