//
//  PreferencesManager.swift
//  AirPlay
//
//  Created by Aj on 17/08/24.
//

import Foundation

@objc class PreferencesManager: NSObject {
    
    // MARK: - Properties
    @objc static let shared = PreferencesManager()
    private let defaults: UserDefaults
    
    // MARK: - Preferance Keys
    private enum UserDefaultsKeys : CaseIterable {
        static let token = "accessToken"
        static let isLoggedIn = "isLoggedIn"
    }
    
    // MARK: - Initialization
    private override init() {
        defaults = UserDefaults.standard
    }
    
    // MARK: - Public Methods
    
    @objc func setAccessToken(_ message: String) {
        defaults.set(message, forKey: UserDefaultsKeys.token)
    }
    
    @objc func getAccessToken() -> String? {
        return defaults.string(forKey: UserDefaultsKeys.token)
    }
    
    @objc func setLoggedIn(_ value: Bool) {
        defaults.set(value, forKey: UserDefaultsKeys.isLoggedIn)
    }
    
    @objc func isLoggedIn() -> Bool {
        return defaults.bool(forKey: UserDefaultsKeys.isLoggedIn)
    }
    
    func clearAllPreferences() {
        defaults.removeObject(forKey: UserDefaultsKeys.token)
    }
}
