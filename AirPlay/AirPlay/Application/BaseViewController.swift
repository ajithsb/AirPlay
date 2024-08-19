//
//  BaseViewController.swift
//  AirPlay
//
//  Created by Aj on 17/08/24.
//

import UIKit

class BaseViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension BaseViewController {
    func showAlert(title: String = "Alert", message: String) {
        // Create the alert controller
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Add an "OK" action to the alert
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            // Handle the "OK" button tap if needed
            print("OK button tapped")
        }
        alertController.addAction(okAction)
        
        // Present the alert
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }

    }
}
