//
//  IPDetailViewController.swift
//  AirPlay
//
//  Created by Aj on 18/08/24.
//

import UIKit

class IPDetailViewController: BaseViewController {
    
    // MARK: - Properties
    @IBOutlet weak var hostNameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var ipLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let viewModel = IPDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callApis()
    }
    
    func callApis() {
        activityIndicator.startAnimating()
        viewModel.getIPAddress()
        viewModel.onComplete = { result in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
            switch result {
            case .success(let success):
                if success {
                    DispatchQueue.main.async { [weak self] in
                        guard let deviceData = self?.viewModel.data else { return }
                        self?.hostNameLabel.text = StringConstants.hostName + (deviceData.hostname ?? "")
                        self?.companyLabel.text = StringConstants.company + (deviceData.org ?? "")
                        self?.regionLabel.text =  StringConstants.region + (deviceData.region ?? "")
                        self?.ipLabel.text =  StringConstants.ip + (deviceData.ip ?? "")
                        
                    }
                }
            case .failure(let error):
                print("An error occurred: \(error.localizedDescription)")
                self.showAlert (message: error.localizedDescription)                // Handle error, show an alert or retry the request
            }
        }
    }
    
}
