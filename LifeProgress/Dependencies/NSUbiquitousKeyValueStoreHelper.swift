//
//  NSUbiquitousKeyValueStoreHelper.swift
//  LifeProgress
//
//  Created by Bartosz Król on 04/04/2023.
//

import Foundation
import Combine

enum NSUbiquitousKeyValueStoreHelper {
    
    // MARK: - Keys
    
    /// Keys used to store objects in the user defautlts.
    enum Key: String {
        case birthday = "Birthday"
        case lifeExpectancy = "LifeExpectancy"
        case isWeeklyNotificationEnabled = "IsWeeklyNotificationEnabled"
        case theme = "Theme"
    }
    
    static let keyValueStore = NSUbiquitousKeyValueStore.default


    // MARK: - Static methods
    
    /// Removes everything from the NSUbiquitousKeyValueStore.
    static func clear() {
        for key in keyValueStore.dictionaryRepresentation.keys {
            keyValueStore.removeObject(forKey: key)
        }
    }
    
    /// Returns life expectancy stored in the NSUbiquitousKeyValueStore.
    static func getLifeExpectancy() -> Int {
        guard let lifeExpectancy = keyValueStore.object(forKey: Key.lifeExpectancy.rawValue) as? Int else {
            return Life.mock.lifeExpectancy
        }
        
        return lifeExpectancy
    }
    
    /// Returns user's birthday stored in the NSUbiquitousKeyValueStore.
    static func getBirthday() -> Date {
        guard let data = keyValueStore.object(forKey: Key.birthday.rawValue) as? Double else {
            return Life.mock.birthday
        }
        
        let birthday = Date(timeIntervalSince1970: data)
        return birthday
    }
    
    /// Returns is weekly notification enabled flag stored in the NSUbiquitousKeyValueStore.
    static func getIsWeeklyNotificationEnabled() -> Bool {
        guard let isWeeklyNotificationEnabled = keyValueStore.object(forKey: Key.isWeeklyNotificationEnabled.rawValue) as? Bool else {
            return false
        }
        
        return isWeeklyNotificationEnabled
    }
    
    /// Returns user's theme stored in the NSUbiquitousKeyValueStore.
    static func getTheme() -> Theme {
        guard
            let data = keyValueStore.string(forKey: Key.theme.rawValue),
            let theme = Theme(rawValue: data) else {
            return Theme.Key.defaultValue
        }

        return theme
    }

    
    /// Saves life expectancy to the NSUbiquitousKeyValueStore.
    static func saveLifeExpectancy(_ lifeExpectancy: Int) {
        keyValueStore.set(lifeExpectancy, forKey: Key.lifeExpectancy.rawValue)
        keyValueStore.synchronize()
    }
    
    /// Saves user's birthday to the NSUbiquitousKeyValueStore.
    static func saveBirthday(_ birthday: Date) {
        keyValueStore.set(birthday.timeIntervalSince1970, forKey: Key.birthday.rawValue)
        keyValueStore.synchronize()
    }

    /// Saves is weekly notification enabled flag to the NSUbiquitousKeyValueStore.
    static func saveIsWeeklyNotificationEnabled(_ isWeeklyNotificationEnabled: Bool) {
        keyValueStore.set(isWeeklyNotificationEnabled, forKey: Key.isWeeklyNotificationEnabled.rawValue)
        keyValueStore.synchronize()
    }
    
    /// Saves user's theme to the NSUbiquitousKeyValueStore.
    static func saveTheme(_ theme: Theme) {
        keyValueStore.set(theme.rawValue, forKey: Key.theme.rawValue)
        keyValueStore.synchronize()
    }
    
    // MARK: - Publishers
    
    /// Creates a publisher that emits the user's birthday whenever it changes in the NSUbiquitousKeyValueStore.
    ///
    /// - Returns: A publisher of type `AnyPublisher<Date, Never>`.
    static func makeBirthdayPublisher() -> AnyPublisher<Date, Never> {
        let externalPublisher = NotificationCenter.default
            .publisher(for: NSUbiquitousKeyValueStore.didChangeExternallyNotification)
            .map { _ in getBirthday() }
            .eraseToAnyPublisher()

        let internalPublisher = keyValueStore
            .publisher(for: \.birthday)
            .map { value in
                guard let birthday = value?.doubleValue else {
                    return Life.mock.birthday
                }

                return Date(timeIntervalSince1970: birthday)
            }
            .eraseToAnyPublisher()
        
        return Publishers.Merge(externalPublisher, internalPublisher)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    
    /// Creates a publisher that emits the user's life expectancy whenever it changes in the NSUbiquitousKeyValueStore.
    ///
    /// - Returns: A publisher of type `AnyPublisher<Int, Never>`.
    static func makeLifeExpectancyPublisher() -> AnyPublisher<Int, Never> {
        let externalPublisher = NotificationCenter.default
            .publisher(for: NSUbiquitousKeyValueStore.didChangeExternallyNotification)
            .map { _ in getLifeExpectancy() }
            .eraseToAnyPublisher()

        let internalPublisher = keyValueStore
            .publisher(for: \.lifeExpectancy)
            .map { value in
                guard let lifeExpectancy = value as? Int else {
                    return Life.mock.lifeExpectancy
                }
                
                return lifeExpectancy
            }
            .eraseToAnyPublisher()
        
        return Publishers.Merge(externalPublisher, internalPublisher)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    /// Creates a publisher that emits the user's theme whenever it changes in the NSUbiquitousKeyValueStore.
    ///
    /// - Returns: A publisher of type `AnyPublisher<Theme, Never>`.
    static func makeThemePublisher() -> AnyPublisher<Theme, Never> {
        let externalPublisher = NotificationCenter.default
            .publisher(for: NSUbiquitousKeyValueStore.didChangeExternallyNotification)
            .map { _ in getTheme() }
            .eraseToAnyPublisher()

        let internalPublisher = keyValueStore
            .publisher(for: \.theme)
            .map { value in
                guard
                    let data = value as? String,
                    let theme = Theme.init(rawValue: data)
                else {
                    return Theme.Key.defaultValue
                }
                
                return theme
            }
            .eraseToAnyPublisher()
        
        return Publishers.Merge(externalPublisher, internalPublisher)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
}

