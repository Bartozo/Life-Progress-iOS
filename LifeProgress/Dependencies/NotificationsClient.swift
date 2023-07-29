//
//  NotificationsClient.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 05/05/2023.
//

import Foundation
import Dependencies
import UserNotifications

/// The `NotificationsClient` is a struct that provides a set of closures for managing notifications in the app.
struct NotificationsClient {
    /// A closure that returns a boolean indicating whether the weekly notification has been scheduled.
    var getDidScheduleWeeklyNotification: () -> Bool
    
    /// A closure that updates the boolean value representing whether the weekly notification has been scheduled.
    var updateDidScheduleWeeklyNotification: (Bool) -> Void
    
    /// A closure that asynchronously returns a `UNMutableNotificationContent` for the weekly notification.
    var getWeeklyNotification: () -> UNMutableNotificationContent
    
    /// A closure that asynchronously requests the user’s authorization to allow notifications.
    var requestPermission: () async -> Void
}

// MARK: Dependency Key

extension NotificationsClient: DependencyKey {
    
    /// A live value of `NotificationsClient` that uses the `UserDefaultsHelper`
    /// and `NSUbiquitousKeyValueStoreHelper` for managing notifications settings.
    static let liveValue = Self(
        getDidScheduleWeeklyNotification: { UserDefaultsHelper.didScheduleWeeklyNotification() },
        updateDidScheduleWeeklyNotification: { UserDefaultsHelper.saveDidScheduleWeeklyNotification($0) },
        getWeeklyNotification: { createWeeklyNotification() },
        requestPermission: {
            let notificationCenter = UNUserNotificationCenter.current()
            do {
                try await notificationCenter.requestAuthorization(options: [.alert, .badge, .sound])
            } catch {
                print("❌ Couldn't request notification authorization")
            }
        }
    )
    
    /// Creates a weekly notification with a randomly selected title and body from a predefined list.
    ///
    /// This function retrieves the user's birthday and life expectancy from `NSUbiquitousKeyValueStoreHelper`,
    /// calculates the user's life progress, and creates a weekly notification with a motivational message.
    ///
    /// - Returns: A `UNMutableNotificationContent` object containing a randomly selected title and body
    ///            with the user's life progress information.
    private static func createWeeklyNotification() -> UNMutableNotificationContent {
        let birthday = NSUbiquitousKeyValueStoreHelper.getBirthday()
        let lifeExpectancy = NSUbiquitousKeyValueStoreHelper.getLifeExpectancy()
        let life = Life.init(birthday: birthday, lifeExpectancy: lifeExpectancy)
        
        let notificationTexts: [(title: String, body: String)] = [
            (
                title: "A New Week in Your Life Journey",
                body: "Another week has passed! You've completed \(life.formattedCurrentYearProgress)% of this year, and you're \(life.formattedProgress)% through your life. Keep going strong!"
            ),
            (
                title: "Weekly Life Progress Snapshot",
                body: "Time flies! This week, your progress stands at \(life.formattedCurrentYearProgress)% for the year and \(life.formattedProgress)% for your life. Keep making the most of your time!"
            ),
            (
                title: "Seize the Day and Your Progress",
                body: "You've lived \(life.formattedProgress)% of your life and experienced \(life.formattedCurrentYearProgress)% of this year. Every moment is an opportunity to achieve your goals and create amazing memories. Make every day count!"
            )
        ]
        
        // Randomly select one of the notification text sets
        let randomIndex = Int.random(in: 0..<notificationTexts.count)
        let selectedNotificationText = notificationTexts[randomIndex]

        // Create a notification
        let content = UNMutableNotificationContent()
        content.title = selectedNotificationText.title
        content.body = selectedNotificationText.body
        content.sound = .default
        
        return content
    }
}


// MARK: Test Dependency Key
extension NotificationsClient: TestDependencyKey {

    /// A preview instance of `NotificationsClient` with mock data for SwiftUI previews and testing purposes.
    static let previewValue = Self(
        getDidScheduleWeeklyNotification: { false },
        updateDidScheduleWeeklyNotification: { _ in },
        getWeeklyNotification: { UNMutableNotificationContent() },
        requestPermission: { }
    )

    /// A test instance of `NotificationsClient` with mock data for unit testing purposes.
    static let testValue = Self(
        getDidScheduleWeeklyNotification: { false },
        updateDidScheduleWeeklyNotification: { _ in },
        getWeeklyNotification: { UNMutableNotificationContent() },
        requestPermission: { }
    )
}

// MARK: Dependency Values

extension DependencyValues {
    
    /// A property wrapper for accessing and updating the `NotificationsClient` instance within the dependency container.
    var notificationsClient: NotificationsClient {
        get { self[NotificationsClient.self] }
        set { self[NotificationsClient.self] = newValue }
    }
}
