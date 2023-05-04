//
//  UserDefaultsHelper.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 04/05/2023.
//

import Foundation

enum UserDefaultsHelper {
    
    // MARK: - Keys
    
    /// Keys used to store objects in the user defautlts.
    enum Key: String {
        case didCompleteOnboarding = "DidCompleteOnboarding"
    }
    
    
    static let defaults = UserDefaults(suiteName: "LifeProgress") ?? .standard


    // MARK: - Static methods
    
    /// Removes everything from the user defaults.
    static func clear() {
        guard let domainName = Bundle.main.bundleIdentifier else {
            return
        }
        
        defaults.removePersistentDomain(forName: domainName)
        defaults.synchronize()
    }
    
    /// Returns did complete onboarding flag stored in the user defaults.
    static func didCompleteOnboarding() -> Bool {
        return defaults.bool(forKey: UserDefaultsHelper.Key.didCompleteOnboarding.rawValue)
    }
    
    /// Saves did complete onboarding flag to the user defaults.
    static func saveDidCompleteOnboarding(_ value: Bool) {
        defaults.set(value, forKey: UserDefaultsHelper.Key.didCompleteOnboarding.rawValue)
    }
}
