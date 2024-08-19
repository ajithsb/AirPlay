//
//  AirPlay.swift
//  AirPlay
//
//  Created by Aj on 18/08/24.
//

import Foundation
import CoreData

class AirPlayService: NSObject, NetServiceBrowserDelegate, NetServiceDelegate {
    var serviceBrowser: NetServiceBrowser!
    var discoveredServices: [NetService] = []
    var context: NSManagedObjectContext!
    var onDevicesUpdated: (() -> Void)?
    
    override init() {
        super.init()
        serviceBrowser = NetServiceBrowser()
        serviceBrowser.delegate = self
    }
    
    func startDiscovery() {
        serviceBrowser.searchForServices(ofType: "_airplay._tcp.", inDomain: "local.")
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        service.delegate = self
        service.resolve(withTimeout: 5.0)
        discoveredServices.append(service)
    }
    
    func netServiceDidResolveAddress(_ sender: NetService) {
        if let ipAddress = getIPAddress(from: sender.addresses ?? []) {
            let port = sender.port
            let status = isReachable(ipAddress: ipAddress, port: port) ? "Reachable" : "Un-Reachable"
            
            saveOrUpdateDevice(name: sender.name, ipAddress: ipAddress, status: status)
        } else {
            saveOrUpdateDevice(name: sender.name, ipAddress: nil, status: "Un-Reachable")
        }
    }

    
    func netService(_ sender: NetService, didNotResolve errorDict: [String: NSNumber]) {
        saveOrUpdateDevice(name: sender.name, ipAddress: nil, status: "Un-Reachable")
    }
    
    func getIPAddress(from addresses: [Data]) -> String? {
        for addressData in addresses {
            let address = addressData.withUnsafeBytes { $0.load(as: sockaddr_in.self) }
            
            // Only handle IPv4 addresses
            if address.sin_family == sa_family_t(AF_INET) {
                // Convert the address to a readable IP string
                guard let ipCString = inet_ntoa(address.sin_addr) else {
                    continue
                }
                let ipAddress = String(cString: ipCString)
                return ipAddress
            }
        }
        return nil
    }
    
    func isReachable(ipAddress: String, port: Int) -> Bool {
        var reachabilityCheck = false
        
        var address = sockaddr_in()
        address.sin_family = sa_family_t(AF_INET)
        address.sin_port = in_port_t(port).bigEndian
        inet_pton(AF_INET, ipAddress, &address.sin_addr)
        
        let sock = socket(AF_INET, SOCK_STREAM, 0)
        defer {
            close(sock)
        }
        
        let result = withUnsafePointer(to: &address) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                connect(sock, $0, socklen_t(MemoryLayout<sockaddr_in>.size))
            }
        }
        
        reachabilityCheck = (result == 0)
        
        return reachabilityCheck
    }
    
    func saveOrUpdateDevice(name: String, ipAddress: String?, status: String) {
        let fetchRequest: NSFetchRequest<AirPlayDevice> = AirPlayDevice.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let device = results.first {
                // Update existing device
                device.ipAddress = ipAddress
                device.status = status
            } else {
                // Create new device
                let newDevice = AirPlayDevice(context: context)
                newDevice.name = name
                newDevice.ipAddress = ipAddress
                newDevice.status = status
            }
            try context.save()
            onDevicesUpdated?()
        } catch {
            print("Failed to save or update device: \(error)")
        }
    }
    
    func loadDevicesFromCoreData() -> [AirPlayDevice] {
        let fetchRequest: NSFetchRequest<AirPlayDevice> = AirPlayDevice.fetchRequest()
        
        do {
            let devices = try context.fetch(fetchRequest)
            return devices
        } catch {
            print("Failed to fetch devices: \(error)")
            return []
        }
    }

    func updateDeviceStatus() {
        let devices = loadDevicesFromCoreData()
        for _ in devices {
            // Start a new discovery for each device
            serviceBrowser.searchForServices(ofType: "_airplay._tcp.", inDomain: "local.")
        }
    }

}
