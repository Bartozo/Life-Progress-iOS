//
//  DeveloperTests.swift
//  LifeProgressTests
//
//  Created by Bartosz Król on 17/06/2023.
//

import XCTest
import ComposableArchitecture

@testable import Life_Progress___Calendar

@MainActor
class DeveloperTests: XCTestCase {
    
    func testDeveloperButtonTapped_ShouldShowConfetti() async {
        let store = TestStore(initialState: DeveloperReducer.State()) {
            DeveloperReducer()
        }
        
        await store.send(.developerButtonTapped) {
            $0.confetti = 1
        }
    }
    
    func testDeveloperButtonTapped_ShouldAddToAnalytics() async {
        var sentEvent = ""
        let store = TestStore(initialState: DeveloperReducer.State()) {
            DeveloperReducer()
        } withDependencies: {
            $0.analyticsClient.send = { event in sentEvent = event }
        }
        
        await store.send(.developerButtonTapped) {
            $0.confetti = 1
        }
        XCTAssertEqual(sentEvent, "developer.developer_button_tapped")
    }
    
    func testConfettiChanged_ShouldUpdateConfettiState() async {
        let store = TestStore(
            initialState: DeveloperReducer.State(confetti: 1)
        ) {
            DeveloperReducer()
        }
        
        await store.send(.set(\.confetti, 0)) {
            $0.confetti = 0
        }
    }
}
