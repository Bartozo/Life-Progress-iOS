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
        let store = TestStore(
            initialState: AboutTheAppReducer.State(
                life: Life.mock,
                isAboutTheCalendarSheetVisible: true
            ),
            reducer: AboutTheAppReducer()
        )
        
        await store.send(.closeAboutTheCalendarSheet) {
            $0.isAboutTheCalendarSheetVisible = false
        }
    }
}
