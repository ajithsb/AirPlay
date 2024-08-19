//
//  UIViewController+Extra.swift
//  AirPlay
//
//  Created by Aj on 18/08/24.
//

import UIKit

let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)

extension UIViewController {
    func gotoLoginVC() {
        DispatchQueue.main.async {
            let  vc  = storyBoard.instantiateViewController(identifier: "LoginViewController") as LoginViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func gotoHomeVC() {
        DispatchQueue.main.async {
            let  vc  = storyBoard.instantiateViewController(identifier: "HomeViewController") as HomeViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func gotoDetailsVC() {
        DispatchQueue.main.async {
            let  vc  = storyBoard.instantiateViewController(identifier: "IPDetailViewController") as IPDetailViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
