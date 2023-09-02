//
//  AddOrEditLifeGoalTests.swift
//  LifeProgressTests
//
//  Created by Bartosz Król on 28/07/2023.
//

import XCTest
import ComposableArchitecture

@testable import Life_Progress___Calendar

@MainActor
class AddOrEditLifeGoalTests: XCTestCase {
    
    func testTitleChanged_ShouldUpdateTitle() async {
        let title = "newTitle"
        let store = TestStore(initialState: AddOrEditLifeGoalReducer.State()) {
            AddOrEditLifeGoalReducer()
        } withDependencies: {
            $0.date.now = {
                Date.createDate(year: 2023, month: 1, day: 1)
            }()
        }
        
        await store.send(.titleChanged(title)) {
            $0.title = title
        }
    }
    
    func testDetailsChanged_ShouldUpdateDetails() async {
        let details = "newDetails"
        let store = TestStore(initialState: AddOrEditLifeGoalReducer.State()) {
            AddOrEditLifeGoalReducer()
        } withDependencies: {
            $0.date.now = {
                Date.createDate(year: 2023, month: 1, day: 1)
            }()
        }
        
        await store.send(.detailsChanged(details)) {
            $0.details = details
        }
    }
    
    func testIsCompletedChanged_ShouldUpdateIsCompletedAndShowConfetti() async {
        let isCompleted = true
        let store = TestStore(initialState: AddOrEditLifeGoalReducer.State()) {
            AddOrEditLifeGoalReducer()
        } withDependencies: {
            $0.date.now = {
                Date.createDate(year: 2023, month: 1, day: 1)
            }()
        }
        
        await store.send(.isCompletedChanged(isCompleted)) {
            $0.isCompleted = isCompleted
        }
        
        await store.receive(.confetti(.showConfetti)) {
            $0.confetti.confetti = 1
        }
    }
    
    func testIsCompletedChanged_ShouldHideDatePicker() async {
        let isCompleted = false
        let store = TestStore(
            initialState: AddOrEditLifeGoalReducer.State(
                isCompleted: true,
                isDatePickerVisible: true
            )
        ) {
            AddOrEditLifeGoalReducer()
        } withDependencies: {
            $0.date.now = {
                Date.createDate(year: 2023, month: 1, day: 1)
            }()
        }
        
        await store.send(.isCompletedChanged(isCompleted)) {
            $0.isCompleted = isCompleted
            $0.isDatePickerVisible = false
        }
    }
    
    func testFinishedAtChanged_ShouldUpdateFinishedAt() async {
        let finishedAt = Date.createDate(year: 2023, month: 1, day: 1)
        let store = TestStore(initialState: AddOrEditLifeGoalReducer.State()) {
            AddOrEditLifeGoalReducer()
        } withDependencies: {
            $0.date.now = {
                Date.createDate(year: 2022, month: 1, day: 1)
            }()
        }
        
        await store.send(.finishedAtChanged(finishedAt)) {
            $0.finishedAt = finishedAt
        }
    }
    
    func testAddButtonTapped_ShouldCreateLifeGoal() async {
        let title = "title"
        let details = "details"
        let finishedAt = Date.createDate(year: 2023, month: 1, day: 1)
        let symbolName = "symbolName"
        var newLifeGoal = LifeGoal(
            id: UUID(),
            title: "",
            finishedAt: Date.now,
            symbolName: "",
            details: ""
        )
        let store = TestStore(
            initialState: AddOrEditLifeGoalReducer.State(
                title: title,
                details: details,
                isCompleted: true,
                symbolName: symbolName,
                finishedAt: finishedAt
            )
        ) {
            AddOrEditLifeGoalReducer()
        } withDependencies: {
            $0.lifeGoalsClient.createLifeGoal = { lifeGoal in
                newLifeGoal = lifeGoal
            }
        }
        
        await store.send(.addButtonTapped)
        await store.receive(.closeButtonTapped)
        
        XCTAssertEqual(newLifeGoal.title, title)
        XCTAssertEqual(newLifeGoal.details, details)
        XCTAssertEqual(newLifeGoal.finishedAt, finishedAt)
        XCTAssertEqual(newLifeGoal.symbolName, symbolName)
    }
    
    func testAddButtonTapped_ShouldAddToAnalytics() async {
        var eventName = ""
        let store = TestStore(initialState: AddOrEditLifeGoalReducer.State()) {
            AddOrEditLifeGoalReducer()
        } withDependencies: {
            $0.analyticsClient.send = { event in
                eventName = event
            }
            $0.date.now = {
                Date.createDate(year: 2023, month: 1, day: 1)
            }()
        }
        store.exhaustivity = .off
        
        await store.send(.addButtonTapped)
        
        XCTAssertEqual(eventName, "add_or_edit_life_goal.add_button_tapped")
    }
    
    func testSaveButtonTapped_ShouldUpdateLifeGoal() async {
        var lifeGoal = LifeGoal(
            id: UUID(),
            title: "title",
            finishedAt: Date.createDate(year: 2023, month: 1, day: 1),
            symbolName: "symbolName",
            details: "details"
        )
        var updatedLifeGoal = LifeGoal(
            id: UUID(),
            title: "",
            finishedAt: Date.now,
            symbolName: "",
            details: ""
        )
        let store = TestStore(
            initialState: AddOrEditLifeGoalReducer.State(
                title: "updatedTitle",
                details: lifeGoal.details,
                isCompleted: true,
                symbolName: lifeGoal.symbolName,
                finishedAt: lifeGoal.finishedAt!,
                lifeGoalToEdit: lifeGoal
            )
        ) {
            AddOrEditLifeGoalReducer()
        } withDependencies: {
            $0.lifeGoalsClient.updateLifeGoal = { lifeGoal in
                updatedLifeGoal = lifeGoal
            }
        }
        
        await store.send(.saveButtonTapped)
        await store.receive(.closeButtonTapped)
        
        XCTAssertEqual(lifeGoal.id, updatedLifeGoal.id)
        XCTAssertEqual("updatedTitle", updatedLifeGoal.title)
        XCTAssertEqual(lifeGoal.details, updatedLifeGoal.details)
        XCTAssertEqual(lifeGoal.finishedAt, updatedLifeGoal.finishedAt)
        XCTAssertEqual(lifeGoal.symbolName, updatedLifeGoal.symbolName)
    }
    
    func testSaveButtonTapped_ShouldAddToAnalytics() async {
        var eventName = ""
        var lifeGoal = LifeGoal(
            id: UUID(),
            title: "title",
            finishedAt: Date.createDate(year: 2023, month: 1, day: 1),
            symbolName: "symbolName",
            details: "details"
        )
        let store = TestStore(
            initialState: AddOrEditLifeGoalReducer.State(
                lifeGoalToEdit: lifeGoal
            )
        ) {
            AddOrEditLifeGoalReducer()
        } withDependencies: {
            $0.analyticsClient.send = { event in
                eventName = event
            }
            $0.date.now = {
                Date.createDate(year: 2023, month: 1, day: 1)
            }()
        }
        store.exhaustivity = .off
        
        await store.send(.saveButtonTapped)
        
        XCTAssertEqual(eventName, "add_or_edit_life_goal.save_button_tapped")
    }
    
    func testShareLifeGoalButtonTapped_ShouldShowShareLifeGoalSheet() async {
        let lifeGoal = LifeGoal(
            id: UUID(),
            title: "title",
            finishedAt: Date.createDate(year: 2023, month: 1, day: 1),
            symbolName: "symbolName",
            details: "details"
        )
        let store = TestStore(
            initialState: AddOrEditLifeGoalReducer.State(
                lifeGoalToEdit: lifeGoal
            )
        ) {
            AddOrEditLifeGoalReducer()
        } withDependencies: {
            $0.date.now = {
                Date.createDate(year: 2023, month: 1, day: 1)
            }()
        }
        
        await store.send(.shareLifeGoalButtonTapped) {
            $0.shareLifeGoal = .init(lifeGoal: lifeGoal)
            $0.isShareLifeGoalSheetVisible = true
        }
    }
    
    func testShareLifeGoalButtonTapped_ShouldntShowShareLifeGoalSheet() async {
        let store = TestStore(initialState: AddOrEditLifeGoalReducer.State()) {
            AddOrEditLifeGoalReducer()
        } withDependencies: {
            $0.date.now = {
                Date.createDate(year: 2023, month: 1, day: 1)
            }()
        }
        
        await store.send(.shareLifeGoalButtonTapped)
    }
    
    func testShareLifeGoalButtonTapped_ShouldAddToAnalytics() async {
        let lifeGoal = LifeGoal(
            id: UUID(),
            title: "title",
            finishedAt: Date.createDate(year: 2023, month: 1, day: 1),
            symbolName: "symbolName",
            details: "details"
        )
        var eventName = ""
        let store = TestStore(
            initialState: AddOrEditLifeGoalReducer.State(
                lifeGoalToEdit: lifeGoal
            )
        ) {
            AddOrEditLifeGoalReducer()
        } withDependencies: {
            $0.analyticsClient.send = { event in
                eventName = event
            }
            $0.date.now = {
                Date.createDate(year: 2023, month: 1, day: 1)
            }()
        }
        store.exhaustivity = .off
        
        await store.send(.shareLifeGoalButtonTapped)
        
        XCTAssertEqual(eventName, "add_or_edit_life_goal.share_life_goal_button_tapped")
    }
    
    func testCloseShareLifeGoalSheet_ShouldCloseLifeGoalSheet() async {
        let lifeGoal = LifeGoal(
            id: UUID(),
            title: "title",
            finishedAt: Date.createDate(year: 2023, month: 1, day: 1),
            symbolName: "symbolName",
            details: "details"
        )
        var eventName = ""
        let store = TestStore(
            initialState: AddOrEditLifeGoalReducer.State(
                shareLifeGoal: .init(lifeGoal: lifeGoal),
                isShareLifeGoalSheetVisible: true
            )
        ) {
            AddOrEditLifeGoalReducer()
        } withDependencies: {
            $0.date.now = {
                Date.createDate(year: 2023, month: 1, day: 1)
            }()
        }
        
        await store.send(.closeShareLifeGoalSheet) {
            $0.shareLifeGoal = nil
            $0.isShareLifeGoalSheetVisible = false
        }
    }
}
