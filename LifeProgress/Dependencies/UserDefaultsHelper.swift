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
        case birthday = "Birthday"
        case lifeExpectancy = "LifeExpectancy"
        case isWeeklyNotificationEnabled = "IsWeeklyNotificationEnabled"
        case theme = "Theme"
    }
    
    
    static let store = NSUbiquitousKeyValueStore.default


    // MARK: - Static methods
    
    /// Removes everything from the NSUbiquitousKeyValueStore.
    static func clear() {
        for key in store.dictionaryRepresentation.keys {
            store.removeObject(forKey: key)
        }
    }
    
    /// Returns life expectancy stored in the NSUbiquitousKeyValueStore.
    static func getLifeExpectancy() -> Int {
        guard let lifeExpectancy = store.object(forKey: Key.lifeExpectancy.rawValue) as? Int else {
            return Life.mock.lifeExpectancy
        }
        
        return lifeExpectancy
    }
    
    /// Returns user's birthday stored in the NSUbiquitousKeyValueStore.
    static func getBirthday() -> Date {
        guard let data = store.object(forKey: Key.birthday.rawValue) as? Double else {
            return Life.mock.birthday
        }
        
        let birthday = Date(timeIntervalSince1970: data)
        return birthday
    }
    
    /// Returns is weekly notification enabled flag stored in the NSUbiquitousKeyValueStore.
    static func getIsWeeklyNotificationEnabled() -> Bool {
        guard let isWeeklyNotificationEnabled = store.object(forKey: Key.isWeeklyNotificationEnabled.rawValue) as? Bool else {
            return false
        }
        
        return isWeeklyNotificationEnabled
    }
    
    /// Returns user's theme stored in the NSUbiquitousKeyValueStore.
    static func getTheme() -> Theme {
        guard
            let data = store.string(forKey: Key.theme.rawValue),
            let theme = Theme(rawValue: data) else {
            return Theme.Key.defaultValue
        }

        return theme
    }

    
    /// Saves life expectancy to the NSUbiquitousKeyValueStore.
    static func saveLifeExpectancy(_ lifeExpectancy: Int) {
        store.set(lifeExpectancy, forKey: Key.lifeExpectancy.rawValue)
    }
    
    /// Saves user's birthday to the NSUbiquitousKeyValueStore.
    static func saveBirthday(_ birthday: Date) {
        store.set(birthday.timeIntervalSince1970, forKey: Key.birthday.rawValue)
    }
    
    /// Saves is weekly notification enabled flag to the NSUbiquitousKeyValueStore.
    static func saveIsWeeklyNotificationEnabled(_ isWeeklyNotificationEnabled: Bool) {
        store.set(isWeeklyNotificationEnabled, forKey: Key.isWeeklyNotificationEnabled.rawValue)
    }
    
    /// Saves user's theme to the NSUbiquitousKeyValueStore.
    static func saveTheme(_ theme: Theme) {
        store.set(theme.rawValue, forKey: Key.theme.rawValue)
    }
}
