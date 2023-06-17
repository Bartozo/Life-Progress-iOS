//
//  LifeExpectancyTests.swift
//  LifeProgressTests
//
//  Created by Bartosz Król on 17/06/2023.
//

import XCTest
import ComposableArchitecture
import Combine

@testable import Life_Progress___Calendar

@MainActor
class LifeExpectancyTests: XCTestCase {
    
    func testOnAppear_ShouldListenToLifeExpectancyChanges() async {
        let lifeExpectancyPublisher = PassthroughSubject<Int, Never>()
        let mainQueue = DispatchQueue.test
        let store = TestStore(
            initialState: LifeExpectancyReducer.State(),
            reducer: LifeExpectancyReducer()
        ) {
            $0.userSettingsClient.lifeExpectancyPublisher = lifeExpectancyPublisher.eraseToAnyPublisher()
            $0.mainQueue = mainQueue.eraseToAnyScheduler()
        }
        
        // Start a life expectancy listener
        let task = await store.send(.onAppear)
  
        lifeExpectancyPublisher.send(100)
        await mainQueue.advance(by: .seconds(1))
        await store.receive(.lifeExpectancyChanged(100)) {
            $0.lifeExpectancy = 100
        }
        
        lifeExpectancyPublisher.send(60)
        await mainQueue.advance(by: .seconds(1))
        await store.receive(.lifeExpectancyChanged(60)) {
            $0.lifeExpectancy = 60
        }
        
        // Cancel the listener
        await task.cancel()
        
        // Verify that new life expectancy values are not received after cancellation
        lifeExpectancyPublisher.send(80)
        await mainQueue.advance(by: .seconds(1))
        XCTAssert(store.state.lifeExpectancy == 60)
    }

    func testLifeExpectancySelectionEnded_ShouldSaveAndUpdateLifeExpectancy() async {
        var lifeExpectancy = 0
        let store = TestStore(
            initialState: LifeExpectancyReducer.State(),
            reducer: LifeExpectancyReducer()
        ) {
            $0.userSettingsClient.updateLifeExpectancy = { @MainActor newLifeExpectancy in
                lifeExpectancy = newLifeExpectancy
            }
        }

        await store.send(.lifeExpectancySelectionEnded(100))
        
        await store.receive(.lifeExpectancyChanged(100)) {
            $0.lifeExpectancy = 100
        }
        XCTAssert(lifeExpectancy == 100)
    }

    func testLifeExpectancyChanged_ShouldUpdateLifeExpectancy() async {
        let store = TestStore(
            initialState: LifeExpectancyReducer.State(),
            reducer: LifeExpectancyReducer()
        )

        await store.send(.lifeExpectancyChanged(100)) {
            $0.lifeExpectancy = 100
        }
    }
    
    func testIsSliderVisibleChanged_ShouldShowSlider() async {
        let store = TestStore(
            initialState: LifeExpectancyReducer.State(),
            reducer: LifeExpectancyReducer()
        )
        
        await store.send(.isSliderVisibleChanged) {
            $0.isSliderVisible = true
        }
    }
    
    func testIsSliderVisibleChanged_ShouldHideSlider() async {
        let store = TestStore(
            initialState: LifeExpectancyReducer.State(isSliderVisible: true),
            reducer: LifeExpectancyReducer()
        )
        
        await store.send(.isSliderVisibleChanged) {
            $0.isSliderVisible = false
        }
    }
}
