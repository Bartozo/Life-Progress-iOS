//
//  WeeklyNotificationTests.swift
//  LifeProgressTests
//
//  Created by Bartosz Król on 17/06/2023.
//

import XCTest
import ComposableArchitecture

@testable import Life_Progress___Calendar

@MainActor
class WeeklyNotificationTests: XCTestCase {
    
    func testIsWeeklyNotificationChanged_ShouldBeEnabled() async {
        let store = TestStore(initialState: WeeklyNotificationReducer.State()) {
            WeeklyNotificationReducer()
        }
        
        await store.send(.set(\.$isWeeklyNotificationEnabled, true)) {
            $0.isWeeklyNotificationEnabled = true
        }
    }
    
    func testIsWeeklyNotificationChanged_ShouldBeDisabled() async {
        let store = TestStore(
            initialState: WeeklyNotificationReducer.State(isWeeklyNotificationEnabled: true)
        ) {
            WeeklyNotificationReducer()
        }
        
        await store.send(.set(\.$isWeeklyNotificationEnabled, false)) {
            $0.isWeeklyNotificationEnabled = false
        }
    }
    
    func testIsWeeklyNotificationChanged_ShouldAddToAnalytics() async {
        var eventName = ""
        var eventPayload = [String: String]()
        let store = TestStore(
            initialState: WeeklyNotificationReducer.State()
        ) {
            WeeklyNotificationReducer()
        } withDependencies: {
            $0.analyticsClient.sendWithPayload = { event, payload in
                eventName = event
                eventPayload = payload
            }
        }
        
        await store.send(.set(\.$isWeeklyNotificationEnabled, true)) {
            $0.isWeeklyNotificationEnabled = true
        }
        
        XCTAssertEqual(eventName, "weekly_notification.is_weekly_notification_changed")
        XCTAssertEqual(eventPayload, ["isWeeklyNotificationEnabled": "true"])
    }
}

