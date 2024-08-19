//
//  ViewController.swift
//  AirPlay
//
//  Created by Aj on 17/08/24.
//

import UIKit

class LoginViewController: BaseViewController {
    // MARK: - Properties
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextFeild: UITextField!
    
    let loginVM = LoginViewModel()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.hideKeyboardWhenTappedAround()
    }
    // MARK: - IBActions
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        loginVM.email = emailTextField.text ?? ""
        loginVM.password = passwordTextFeild.text ?? ""
        let status = loginVM.checkLoginStatus()
        if !status.0 {
            showAlert(message: status.1)
        } else {
            //            LoginManager.sharedInstance().login { success, error in
            //                if success {
            //                    // Handle successful login, e.g., navigate to the main screen
            //                    print("Login successful!")
            //                    PreferencesManager.shared.setLoggedIn(true)
            //                    self.gotoHomeVC()
            //                } else {
            //                    // Handle failure, e.g., show an error message
            //                    if let error = error {
            //                        print("Login failed with error: \(error.localizedDescription)")
            //                    }
            //                    self.mockData()
            //                }
            //            }
            mockData()
        }
    }
    
    func mockData() {
        PreferencesManager.shared.setLoggedIn(true)
        self.gotoHomeVC()
    }
}
// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
