//
//  LoginViewModel.swift
//  AirPlay
//
//  Created by Aj on 18/08/24.
//

import Foundation

class LoginViewModel {
    var email = ""
    var password = ""
    
    func checkLoginStatus() -> (Bool, String) {
        if !email.isValidEmail {
            return (false, "Enter valid email")
        }
        if !password.isValidPassword {
            return (false, "Enter valid password")
        }
        return (true, "")
    }
}
