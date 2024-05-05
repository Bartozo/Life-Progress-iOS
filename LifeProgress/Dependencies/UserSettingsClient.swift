//
//  UserSettingsClient.swift
//  LifeProgress
//
//  Created by Bartosz Król on 26/03/2023.
//

import Foundation
import Dependencies
import Combine

/// The `UserSettingsClient` is a struct that provides a set of closures for managing user settings.
struct UserSettingsClient {
    /// A closure that returns the user's birthday.
    var getBirthday: () -> Date
    
    /// A closure that asynchronously updates the user's birthday.
    var updateBirthday: @Sendable (Date) async -> Void
    
    /// A closure that returns the user's life expectancy..
    var getLifeExpectancy: () -> Int
    
    /// A closure that asynchronously updates the user's life expectancy.
    var updateLifeExpectancy: @Sendable (Int) async -> Void
    
    /// A closure that returns the user's weekly notification setting.
    var getIsWeeklyNotificationEnabled: () -> Bool
    
    /// A closure that asynchronously updates the user's weekly notification setting.
    var updateIsWeeklyNotificationEnabled: @Sendable (Bool) async -> Void
    
    /// A closure that returns the user's `Theme`.
    var getTheme: () -> Theme
    
    /// A closure that asynchronously updates the user's `Theme`.
    var updateTheme: @Sendable(Theme) async -> Void
    
    /// A publisher that emits the user's birthday whenever it changes.
    var birthdayPublisher: AnyPublisher<Date, Never>
    
    /// A publisher that emits the user's life expectancy  whenever it changes.
    var lifeExpectancyPublisher: AnyPublisher<Int, Never>
    
    /// A publisher that emits the user's theme whenever it changes.
    var themePublisher: AnyPublisher<Theme, Never>
}

// MARK: Dependency Key

extension UserSettingsClient: DependencyKey {
    
    /// A live value of `UserSettingsClient` that uses the `NSUbiquitousKeyValueStoreHelper`
    /// and `UserDefaultsHelper` for managing user settings.
    static let liveValue = Self(
        getBirthday: { NSUbiquitousKeyValueStoreHelper.getBirthday() },
        updateBirthday: { NSUbiquitousKeyValueStoreHelper.saveBirthday($0) },
        getLifeExpectancy: { NSUbiquitousKeyValueStoreHelper.getLifeExpectancy() },
        updateLifeExpectancy: { NSUbiquitousKeyValueStoreHelper.saveLifeExpectancy($0) },
        getIsWeeklyNotificationEnabled: { NSUbiquitousKeyValueStoreHelper.getIsWeeklyNotificationEnabled() },
        updateIsWeeklyNotificationEnabled: { NSUbiquitousKeyValueStoreHelper.saveIsWeeklyNotificationEnabled($0) },
        getTheme: { NSUbiquitousKeyValueStoreHelper.getTheme() },
        updateTheme: { NSUbiquitousKeyValueStoreHelper.saveTheme($0) },
        birthdayPublisher: makeBirthdayPublisher(),
        lifeExpectancyPublisher: makeLifeExpectancyPublisher(),
        themePublisher: makeThemePublisher()
    )
    
    /// Creates a publisher that emits the user's birthday whenever it changes.
    ///
    /// - Returns: A publisher of type `AnyPublisher<Date, Never>`.
    private static func makeBirthdayPublisher() -> AnyPublisher<Date, Never> {
        return NSUbiquitousKeyValueStoreHelper.makeBirthdayPublisher()
    }
    
    /// Creates a publisher that emits the user's life expectancy whenever it changes.
    ///
    /// - Returns: A publisher of type `AnyPublisher<Int, Never>`.
    private static func makeLifeExpectancyPublisher() -> AnyPublisher<Int, Never> {
        return NSUbiquitousKeyValueStoreHelper.makeLifeExpectancyPublisher()
    }
    
    /// Creates a publisher that emits the user's theme whenever it changes.
    ///
    /// - Returns: A publisher of type `AnyPublisher<Theme, Never>`.
    private static func makeThemePublisher() -> AnyPublisher<Theme, Never> {
        return NSUbiquitousKeyValueStoreHelper.makeThemePublisher()
    }
}

// MARK: Test Dependency Key
extension UserSettingsClient: TestDependencyKey {

    /// A preview instance of `UserSettingsClient` with mock data for SwiftUI previews and testing purposes.
    static let previewValue = Self(
        getBirthday: { Life.mock.birthday },
        updateBirthday: { _ in },
        getLifeExpectancy: { Life.mock.lifeExpectancy },
        updateLifeExpectancy: { _ in },
        getIsWeeklyNotificationEnabled: { false },
        updateIsWeeklyNotificationEnabled: { _ in },
        getTheme: { Theme.blue },
        updateTheme: { _ in },
        birthdayPublisher: makeTestBirthdayPublisher(),
        lifeExpectancyPublisher: makeTestLifeExpectancyPublisher(),
        themePublisher: makeThemePublisher()
    )

    /// A test instance of `UserSettingsClient` with mock data for unit testing purposes.
    static let testValue = Self(
        getBirthday: { Life.mock.birthday },
        updateBirthday: { _ in },
        getLifeExpectancy: { Life.mock.lifeExpectancy },
        updateLifeExpectancy: { _ in },
        getIsWeeklyNotificationEnabled: { false },
        updateIsWeeklyNotificationEnabled: { _ in },
        getTheme: { Theme.blue },
        updateTheme: { _ in },
        birthdayPublisher: makeTestBirthdayPublisher(),
        lifeExpectancyPublisher: makeTestLifeExpectancyPublisher(),
        themePublisher: makeThemePublisher()
    )
    
    /// Creates a test publisher that emits a constant mock birthday.
    ///
    /// - Returns: A publisher of type `AnyPublisher<Date, Never>`.
    private static func makeTestBirthdayPublisher() -> AnyPublisher<Date, Never> {
        return Just(Life.mock.birthday).eraseToAnyPublisher()
    }
    
    /// Creates a test publisher that emits a constant mock life expectancy.
    ///
    /// - Returns: A publisher of type `AnyPublisher<Int, Never>`.
    private static func makeTestLifeExpectancyPublisher() -> AnyPublisher<Int, Never> {
        return Just(Life.mock.lifeExpectancy).eraseToAnyPublisher()
    }
    
    /// Creates a test publisher that emits a constant mock theme.
    ///
    /// - Returns: A publisher of type `AnyPublisher<Theme, Never>`.
    private static func makeTestThemePublisher() -> AnyPublisher<Theme, Never> {
        return Just(Theme.Key.defaultValue).eraseToAnyPublisher()
    }
}

// MARK: Dependency Values

extension DependencyValues {
    
    /// A property wrapper for accessing and updating the `UserSettingsClient` instance within the dependency container.
    var userSettingsClient: UserSettingsClient {
        get { self[UserSettingsClient.self] }
        set { self[UserSettingsClient.self] = newValue }
    }
}
