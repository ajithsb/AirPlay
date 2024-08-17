//
//  CustomActivityIndicator.swift
//  AirPlay
//
//  Created by Aj on 17/08/24.
//
import UIKit

class CustomActivityIndicator: UIView {

    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let backgroundView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        // Set up the background view
        backgroundView.frame = bounds
        backgroundView.backgroundColor = UIColor(white: 0, alpha: 0.7)
        backgroundView.layer.cornerRadius = 10
        backgroundView.clipsToBounds = true
        addSubview(backgroundView)

        // Set up the activity indicator
        activityIndicator.center = center
        activityIndicator.color = .white
        backgroundView.addSubview(activityIndicator)
    }

    func startAnimating() {
        isHidden = false
        activityIndicator.startAnimating()
    }

    func stopAnimating() {
        activityIndicator.stopAnimating()
        isHidden = true
    }
}
