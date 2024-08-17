//
//  BaseViewController.swift
//  AirPlay
//
//  Created by Aj on 17/08/24.
//

import UIKit

class BaseViewController: UIViewController {

    let activityIndicator = CustomActivityIndicator()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the frame or constraints for the activity indicator
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
    }
    
    func activityIndicatorStartAnimating() {
        // Start the activity indicator animation
        activityIndicator.startAnimating()
        
        // Simulate a network request or task
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.activityIndicator.stopAnimating()
        }
    }
}
