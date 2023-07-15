//
//  ConfettiTests.swift
//  LifeProgressTests
//
//  Created by Bartosz Król on 25/06/2023.
//

import XCTest
import ComposableArchitecture

@testable import Life_Progress___Calendar

@MainActor
class ConfettiTests: XCTestCase {
    
    func testConfettiChanged_ShouldUpdateConfetti() async {
        let store = TestStore(
            initialState: ConfettiReducer.State(),
            reducer: ConfettiReducer()
        )
        let confetti = 1
    
    
        await store.send(.confettiChanged(confetti)) {
            $0.confetti = confetti
        }
    }
    
    func testShowConfetti_ShouldShowConfetti() async {
        let store = TestStore(
            initialState: ConfettiReducer.State(),
            reducer: ConfettiReducer()
        )
        
        await store.send(.showConfetti) {
            $0.confetti = 1
        }
    }
    
    func testShowConfetti_ShouldAddToAnalytics() async {
        var eventName = ""
        let store = TestStore(
            initialState: ConfettiReducer.State(),
            reducer: ConfettiReducer()
        ) {
            $0.analyticsClient.send = { event in
                eventName = event
            }
        }
        
        await store.send(.showConfetti) {
            $0.confetti = 1
        }
        
        XCTAssertEqual(eventName, "confetti.show_confetti")
    }
}


