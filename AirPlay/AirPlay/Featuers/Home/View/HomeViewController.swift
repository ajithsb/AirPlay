//
//  HomeViewController.swift
//  AirPlay
//
//  Created by Aj on 18/08/24.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, NetServiceDelegate {
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    
    var devices: [AirPlayDevice] = []
    var airPlayService: AirPlayService!
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "AirPlayDevice")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        airPlayService = AirPlayService()
        airPlayService.context = persistentContainer.viewContext
        
        // Update the table view when new devices are discovered
        airPlayService.onDevicesUpdated = { [weak self] in
            self?.devices = self?.airPlayService.loadDevicesFromCoreData() ?? []
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        airPlayService.startDiscovery()
        tableView.register(DeviceTableViewCell.nib(), forCellReuseIdentifier: DeviceTableViewCell.identifier)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
}
// MARK: - UITableViewDataSource, UITableViewDelegate

extension HomeViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DeviceTableViewCell = tableView.dequeueReusableCell(withIdentifier: DeviceTableViewCell.identifier) as! DeviceTableViewCell
        cell.config(data: devices[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        gotoDetailsVC()
    }
    
}
