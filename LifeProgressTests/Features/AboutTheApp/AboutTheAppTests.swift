//
//  AboutTheAppTests.swift
//  LifeProgressTests
//
//  Created by Bartosz Król on 29/07/2023.
//

import XCTest
import ComposableArchitecture

@testable import Life_Progress___Calendar

@MainActor
class AboutTheAppTests: XCTestCase {
    
    func testCloseAboutTheCalendarSheet_ShouldHideAboutTheCalendarSheet() async {
        var isDismissed = false
        let store = TestStore(
            initialState: AboutTheAppReducer.State(life: Life.mock)
        ) {
            AboutTheAppReducer()
        } withDependencies: {
            $0.dismiss = DismissEffect {
                isDismissed = true
            }
        }
        
        await store.send(.closeAboutTheCalendarSheet)
        XCTAssertTrue(isDismissed, "Sheet should be dismissed")
    }
}
