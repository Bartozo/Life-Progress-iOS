//
//  UserDefaultsHelper.swift
//  LifeProgress
//
//  Created by Bartosz Król on 19/03/2023.
//

import Foundation

enum UserDefaultsHelper {
    
    // MARK: - Keys
    
    /// Keys used to store objects in the user defautlts.
    enum Key: String {
        case birthday
        case lifeExpectancy
        case isWeeklyNotificationEnabled
        case theme
    }
    
    
    static let defaults = UserDefaults(suiteName: "test") ?? .standard


    // MARK: - Static methods
    
    /// Removes everything from the user defaults.
    static func clear() {
        guard let domainName = Bundle.main.bundleIdentifier else {
            return
        }
        
        defaults.removePersistentDomain(forName: domainName)
        defaults.synchronize()
    }
    
    /// Returns life expectancy stored in the user defaults.
    static func getLifeExpectancy() -> Int {
        guard let lifeExpectancy = defaults.object(forKey: UserDefaultsHelper.Key.lifeExpectancy.rawValue) as? Int else {
            return Life.mock.lifeExpectancy
        }
        
        return lifeExpectancy
    }
    
    /// Returns user's birthday stored in the user defaults.
    static func getBirthday() -> Date {
        guard let data = defaults.object(forKey: UserDefaultsHelper.Key.birthday.rawValue) as? Double else {
            return Life.mock.birthday
        }
        
        let birthday = Date(timeIntervalSince1970: data)
        return birthday
    }
    
    /// Returns is weekly notification enabled flag stored in the user defaults.
    static func getIsWeeklyNotificationEnabled() -> Bool {
        guard let isWeeklyNotificationEnabled = defaults.object(forKey: UserDefaultsHelper.Key.isWeeklyNotificationEnabled.rawValue) as? Bool else {
            return false
        }
        
        return isWeeklyNotificationEnabled
    }
    
    /// Returns user's theme stored in the user defaults.
    static func getTheme() -> Theme {
        guard
            let data = defaults.string(forKey: UserDefaultsHelper.Key.theme.rawValue),
            let theme = Theme(rawValue: data) else {
            return Theme.Key.defaultValue
        }

        return theme
    }

    
    /// Saves life expectancy to the user defaults.
    static func saveLifeExpectancy(_ lifeExpectancy: Int) {
        defaults.set(lifeExpectancy, forKey: UserDefaultsHelper.Key.lifeExpectancy.rawValue)
    }
    
    /// Saves user's birthday to the user defaults.
    static func saveBirthday(_ birthday: Date) {
        defaults.set(birthday.timeIntervalSince1970, forKey: UserDefaultsHelper.Key.birthday.rawValue)
    }
    
    /// Saves is weekly notification enabled flag to the user defaults.
    static func saveIsWeeklyNotificationEnabled(_ isWeeklyNotificationEnabled: Bool) {
        defaults.set(isWeeklyNotificationEnabled, forKey: UserDefaultsHelper.Key.isWeeklyNotificationEnabled.rawValue)
    }
    
    /// Saves user's theme to the user defaults.
    static func saveTheme(_ theme: Theme) {
        defaults.set(theme.rawValue, forKey: UserDefaultsHelper.Key.theme.rawValue)
    }
}


extension UserDefaults {
    @objc dynamic var birthday: Double {
        return double(forKey: "birthday")
    }
}
