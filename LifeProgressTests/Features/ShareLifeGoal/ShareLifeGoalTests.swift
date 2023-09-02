//
//  ShareLifeGoalTests.swift
//  LifeProgressTests
//
//  Created by Bartosz Król on 06/08/2023.
//

import XCTest
import ComposableArchitecture

@testable import Life_Progress___Calendar

@MainActor
class ShareLifeGoalTests: XCTestCase {
    
    func testThemeChanged_ShouldUpdateTheme() async {
        let store = TestStore(
            initialState: ShareLifeGoalReducer.State(
                lifeGoal: LifeGoal(
                    id: UUID(),
                    title: "title",
                    finishedAt: Date.createDate(year: 2023, month: 1, day: 1),
                    symbolName: "symbolName",
                    details: "details"
                )
            )
        ) {
            ShareLifeGoalReducer()
        }
        let theme: ShareLifeGoalReducer.State.Theme = .dark
        
        await store.send(.themeChanged(theme)) {
            $0.theme = theme
        }
    }
    
    func testIsTimeVisibleChanged_ShouldUpdateIsTimeVisible() async {
        let store = TestStore(
            initialState: ShareLifeGoalReducer.State(
                lifeGoal: LifeGoal(
                    id: UUID(),
                    title: "title",
                    finishedAt: Date.createDate(year: 2023, month: 1, day: 1),
                    symbolName: "symbolName",
                    details: "details"
                )
            )
        ) {
            ShareLifeGoalReducer()
        }
        
        await store.send(.isTimeVisibleChanged(false)) {
            $0.isTimeVisible = false
        }
    }
    
    func testIsWatermarkVisibleChanged_ShouldUpdateIsWatermarkVisible() async {
        let store = TestStore(
            initialState: ShareLifeGoalReducer.State(
                lifeGoal: LifeGoal(
                    id: UUID(),
                    title: "title",
                    finishedAt: Date.createDate(year: 2023, month: 1, day: 1),
                    symbolName: "symbolName",
                    details: "details"
                )
            )
        ) {
            ShareLifeGoalReducer()
        }
        
        await store.send(.isWatermarkVisibleChanged(false)) {
            $0.isWatermarkVisible = false
        }
    }
    
    func testShareButtonTapped_ShouldAddToAnalytics() async {
        var eventName = ""
        let store = TestStore(
            initialState: ShareLifeGoalReducer.State(
                lifeGoal: LifeGoal(
                    id: UUID(),
                    title: "title",
                    finishedAt: Date.createDate(year: 2023, month: 1, day: 1),
                    symbolName: "symbolName",
                    details: "details"
                )
            )
        ) {
            ShareLifeGoalReducer()
        } withDependencies: {
            $0.analyticsClient.send = { event in
                eventName = event
            }
        }
        store.exhaustivity = .off
        
        await store.send(.shareButtonTapped)
        
        XCTAssertEqual(eventName, "share_life_goal.share_button_tapped")
    }
}

