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
    /// A closure that returns the user's birthday as a `Date` object.
    var getBirthday: () -> Date
    
    /// A closure that asynchronously updates the user's birthday with a new `Date` object.
    var updateBirthday: @Sendable (Date) async -> Void
    
    /// A closure that returns the user's life expectancy as an `Int`.
    var getLifeExpectancy: () -> Int
    
    /// A closure that asynchronously updates the user's life expectancy with a new `Int` value.
    var updateLifeExpectancy: @Sendable (Int) async -> Void
    
    /// A closure that returns the user's weekly notification setting as a `Bool`.
    var getIsWeeklyNotificationEnabled: () -> Bool
    
    /// A closure that asynchronously updates the user's weekly notification setting with a new `Bool` value.
    var updateIsWeeklyNotificationEnabled: @Sendable (Bool) async -> Void
    
    /// A closure that returns the user's theme as a `Theme` object.
    var getTheme: () -> Theme
    
    /// A closure that asynchronously updates the user's theme with a new `Theme` object.
    var updateTheme: @Sendable(Theme) async -> Void
    
    /// A publisher that emits the user's birthday as a `Date` object whenever it changes.
    var birthdayPublisher: AnyPublisher<Date, Never>
}

// MARK: Dependency Key

extension UserSettingsClient: DependencyKey {
    
    /// A live value of `UserSettingsClient` that uses the `UserDefaultsHelper` for managing user settings.
    static let liveValue = Self(
        getBirthday: { UserDefaultsHelper.getBirthday() },
        updateBirthday: { UserDefaultsHelper.saveBirthday($0) },
        getLifeExpectancy: { UserDefaultsHelper.getLifeExpectancy() },
        updateLifeExpectancy: { UserDefaultsHelper.saveLifeExpectancy($0) },
        getIsWeeklyNotificationEnabled: { UserDefaultsHelper.getIsWeeklyNotificationEnabled() },
        updateIsWeeklyNotificationEnabled: { UserDefaultsHelper.saveIsWeeklyNotificationEnabled($0) },
        getTheme: { UserDefaultsHelper.getTheme() },
        updateTheme: { UserDefaultsHelper.saveTheme($0) },
        birthdayPublisher: makeBirthdayPublisher()
    )
    
    /// Creates a birthday publisher that emits the user's birthday as a `Date` object whenever it changes.
    ///
    /// - Returns: A publisher of type `AnyPublisher<Date, Never>`.
    private static func makeBirthdayPublisher() -> AnyPublisher<Date, Never> {
        return UserDefaultsHelper.defaults.publisher(for: \.birthday)
            .map {
                Date(timeIntervalSince1970: $0)
            }
            .eraseToAnyPublisher()
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
        birthdayPublisher: makeTestBirthdayPublisher()
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
        birthdayPublisher: makeTestBirthdayPublisher()
    )
    
    /// Creates a test birthday publisher that emits a constant mock birthday as a `Date` object.
    ///
    /// - Returns: A publisher of type `AnyPublisher<Date, Never>`.
    private static func makeTestBirthdayPublisher() -> AnyPublisher<Date, Never> {
        return Just(Life.mock.birthday).eraseToAnyPublisher()
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
