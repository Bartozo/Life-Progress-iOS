//
//  RootTests.swift
//  LifeProgressTests
//
//  Created by Bartosz Król on 05/05/2024.
//

import XCTest
import ComposableArchitecture

@testable import Life_Progress___Calendar

@MainActor
class RootTests: XCTestCase {
    
    func testDidScheduleWeeklyNotificationChanged_ShouldUpdateDidScheduleWeeklyNotification() async {
        let store = TestStore(initialState: RootReducer.State()) {
            RootReducer()
        }
        
        await store.send(.didScheduleWeeklyNotificationChanged(true)) {
            $0.didScheduleWeeklyNotification = true
        }
    }
}


