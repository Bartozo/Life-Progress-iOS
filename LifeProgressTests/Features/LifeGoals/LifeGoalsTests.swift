//
//  LifeGoalsTests.swift
//  LifeProgressTests
//
//  Created by Bartosz Król on 28/07/2023.
//

import XCTest
import ComposableArchitecture

@testable import Life_Progress___Calendar

@MainActor
class LifeGoalsTests: XCTestCase {
    
    func testOnAppear_ShouldFetchLifeGoals() async {
        let lifeGoals = [
            LifeGoal(
                id: UUID(),
                title: "title",
                finishedAt: Date.createDate(year: 2023, month: 1, day: 1),
                symbolName: "symbolName",
                details: "details"
            ),
            LifeGoal(
                id: UUID(),
                title: "title2",
                finishedAt: Date.createDate(year: 2023, month: 1, day: 2),
                symbolName: "symbolName2",
                details: "details2"
            ),
        ]
        let store = TestStore(initialState: LifeGoalsReducer.State()) {
            LifeGoalsReducer()
        } withDependencies: {
            $0.lifeGoalsClient.fetchLifeGoals = {
                return lifeGoals
            }
        }
        
        await store.send(.onAppear)
        
        await store.receive(.lifeGoalsChanged(lifeGoals)) {
            $0.lifeGoals = lifeGoals
        }
    }
    
    func testListTypeChanged_ShouldUpdateListType() async {
        let store = TestStore(initialState: LifeGoalsReducer.State()) {
            LifeGoalsReducer()
        }
        
        await store.send(.set(\.$listType, .completed)) {
            $0.listType = .completed
        }
        
        await store.send(.set(\.$listType, .uncompleted)) {
            $0.listType = .uncompleted
        }
    }
    
    func testLifeGoalsChanged_ShouldUpdateLifeGoals() async {
        let lifeGoals = [
            LifeGoal(
                id: UUID(),
                title: "title",
                finishedAt: Date.createDate(year: 2023, month: 1, day: 1),
                symbolName: "symbolName",
                details: "details"
            ),
            LifeGoal(
                id: UUID(),
                title: "title2",
                finishedAt: Date.createDate(year: 2023, month: 1, day: 2),
                symbolName: "symbolName2",
                details: "details2"
            ),
        ]
        let store = TestStore(initialState: LifeGoalsReducer.State()) {
            LifeGoalsReducer()
        }
        
        await store.send(.lifeGoalsChanged(lifeGoals)) {
            $0.lifeGoals = lifeGoals
        }
    }
    
    func testAddButtonTapped_ShouldShowAddOrEditLifeGoalSheet() async {
        let store = TestStore(initialState: LifeGoalsReducer.State()) {
            LifeGoalsReducer()
        } withDependencies: {
            $0.date.now = {
                Date.createDate(year: 2023, month: 1, day: 1)
            }()
        }
        
        await store.send(.addButtonTapped) {
            $0.addOrEditLifeGoal = .init()
        }
    }
    
    func testAddButtonTapped_ShouldShowAddOrEditLifeGoalSheetWhenExceededLifeGoalsLimitWithPremium() async {
        let lifeGoals = [
            LifeGoal(
                id: UUID(),
                title: "title",
                finishedAt: Date.createDate(year: 2023, month: 1, day: 1),
                symbolName: "symbolName",
                details: "details"
            ),
            LifeGoal(
                id: UUID(),
                title: "title2",
                finishedAt: Date.createDate(year: 2023, month: 1, day: 2),
                symbolName: "symbolName2",
                details: "details2"
            ),
            LifeGoal(
                id: UUID(),
                title: "title3",
                finishedAt: Date.createDate(year: 2023, month: 1, day: 3),
                symbolName: "symbolName3",
                details: "details3"
            ),
        ]
        let store = TestStore(
            initialState: LifeGoalsReducer.State(
                iap: IAPReducer.State(
                    purchasedProductIDs: ["com.bartozo.lifeprogress.premium"]
                ),
                lifeGoals: lifeGoals
            )
        ) {
            LifeGoalsReducer()
        } withDependencies: {
            $0.date.now = {
                Date.createDate(year: 2023, month: 1, day: 1)
            }()
        }
        
        await store.send(.addButtonTapped) {
            $0.addOrEditLifeGoal = .init()
        }
    }
    
    func testAddButtonTapped_ShouldShowIAPSheetWhenExceededLifeGoalsLimit() async {
        let lifeGoals = [
            LifeGoal(
                id: UUID(),
                title: "title",
                finishedAt: Date.createDate(year: 2023, month: 1, day: 1),
                symbolName: "symbolName",
                details: "details"
            ),
            LifeGoal(
                id: UUID(),
                title: "title2",
                finishedAt: Date.createDate(year: 2023, month: 1, day: 2),
                symbolName: "symbolName2",
                details: "details2"
            ),
            LifeGoal(
                id: UUID(),
                title: "title3",
                finishedAt: Date.createDate(year: 2023, month: 1, day: 3),
                symbolName: "symbolName3",
                details: "details3"
            ),
        ]
        let store = TestStore(
            initialState: LifeGoalsReducer.State(
                lifeGoals: lifeGoals
            )
        ) {
            LifeGoalsReducer()
        }
        
        await store.send(.addButtonTapped) {
            $0.iap.isSheetVisible = true
        }
    }
    
    func testAddButtonTapped_ShouldAddToAnalytics() async {
        var eventName = ""
        let store = TestStore(initialState: LifeGoalsReducer.State()) {
            LifeGoalsReducer()
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
        
        XCTAssertEqual(eventName, "life_goals.add_button_tapped")
    }
    
    func testSwipeToDelete_ShouldDeleteLifeGoal() async {
        let lifeGoal = LifeGoal(
            id: UUID(),
            title: "title",
            finishedAt: Date.createDate(year: 2023, month: 1, day: 1),
            symbolName: "symbolName",
            details: "details"
        )
        var deletedLifeGoal = LifeGoal(
            id: UUID(),
            title: "",
            finishedAt: Date.now,
            symbolName: "",
            details: ""
        )
        let store = TestStore(initialState: LifeGoalsReducer.State()) {
            LifeGoalsReducer()
        } withDependencies: {
            $0.lifeGoalsClient.deleteLifeGoal = { lifeGoal in
                deletedLifeGoal = lifeGoal
            }
        }
        
        await store.send(.swipeToDelete(lifeGoal))
        await store.receive(.onAppear)
        await store.receive(.lifeGoalsChanged([]))
        
        XCTAssertEqual(lifeGoal, deletedLifeGoal)
    }
    
    func testSwipeToDelete_ShouldAddToAnalytics() async {
        var eventName = ""
        let lifeGoal = LifeGoal(
            id: UUID(),
            title: "title",
            finishedAt: Date.createDate(year: 2023, month: 1, day: 1),
            symbolName: "symbolName",
            details: "details"
        )
        let store = TestStore(initialState: LifeGoalsReducer.State()) {
            LifeGoalsReducer()
        } withDependencies: {
            $0.analyticsClient.send = { event in
                eventName = event
            }
        }
        store.exhaustivity = .off
        
        await store.send(.swipeToDelete(lifeGoal))
        
        XCTAssertEqual(eventName, "life_goals.swipe_to_delete")
    }
    
    func testSwipeToComplete_ShouldMarkLifeGoalAsCompleted() async {
        let lifeGoal = LifeGoal(
            id: UUID(),
            title: "title",
            finishedAt: nil,
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
        let store = TestStore(initialState: LifeGoalsReducer.State()) {
            LifeGoalsReducer()
        } withDependencies: {
            $0.lifeGoalsClient.updateLifeGoal = { lifeGoal in
                updatedLifeGoal = lifeGoal
            }
            $0.date.now = {
                Date.createDate(year: 2023, month: 1, day: 1)
            }()
        }
        
        await store.send(.swipeToComplete(lifeGoal))
        await store.receive(.onAppear)
        await store.receive(.confetti(.showConfetti)) {
            $0.confetti.confetti = 1
        }
        await store.receive(.lifeGoalsChanged([]))
        
        XCTAssertEqual(lifeGoal.id, updatedLifeGoal.id)
        XCTAssertEqual(lifeGoal.title, updatedLifeGoal.title)
        XCTAssertEqual(Date.createDate(year: 2023, month: 1, day: 1), updatedLifeGoal.finishedAt)
        XCTAssertEqual(lifeGoal.symbolName, updatedLifeGoal.symbolName)
        XCTAssertEqual(lifeGoal.details, updatedLifeGoal.details)
    }
    
    func testSwipeToComplete_ShouldAddToAnalytics() async {
        var eventNames = [""]
        let lifeGoal = LifeGoal(
            id: UUID(),
            title: "title",
            finishedAt: nil,
            symbolName: "symbolName",
            details: "details"
        )
        let store = TestStore(initialState: LifeGoalsReducer.State()) {
            LifeGoalsReducer()
        } withDependencies: {
            $0.analyticsClient.send = { event in
                eventNames.append(event)
            }
            $0.date.now = {
                Date.createDate(year: 2023, month: 1, day: 1)
            }()
        }
        store.exhaustivity = .off
        
        await store.send(.swipeToComplete(lifeGoal))
        
        XCTAssertTrue(eventNames.contains("life_goals.swipe_to_complete"))
    }
    
    func testSwipeToUncomplete_ShouldMarkLifeGoalAsUncompleted() async {
        let lifeGoal = LifeGoal(
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
        let store = TestStore(initialState: LifeGoalsReducer.State()) {
            LifeGoalsReducer()
        } withDependencies: {
            $0.lifeGoalsClient.updateLifeGoal = { lifeGoal in
                updatedLifeGoal = lifeGoal
            }
        }
        
        await store.send(.swipeToUncomplete(lifeGoal))
        await store.receive(.onAppear)
        await store.receive(.lifeGoalsChanged([]))
        
        XCTAssertEqual(lifeGoal.id, updatedLifeGoal.id)
        XCTAssertEqual(lifeGoal.title, updatedLifeGoal.title)
        XCTAssertEqual(nil, updatedLifeGoal.finishedAt)
        XCTAssertEqual(lifeGoal.symbolName, updatedLifeGoal.symbolName)
        XCTAssertEqual(lifeGoal.details, updatedLifeGoal.details)
    }
    
    func testSwipeToUncomplete_ShouldAddToAnalytics() async {
        var eventName = ""
        let lifeGoal = LifeGoal(
            id: UUID(),
            title: "title",
            finishedAt: nil,
            symbolName: "symbolName",
            details: "details"
        )
        let store = TestStore(initialState: LifeGoalsReducer.State()) {
            LifeGoalsReducer()
        } withDependencies: {
            $0.analyticsClient.send = { event in
                eventName = event
            }
        }
        store.exhaustivity = .off
        
        await store.send(.swipeToUncomplete(lifeGoal))
        
        XCTAssertEqual(eventName, "life_goals.swipe_to_uncomplete")
    }
    
    func testSwipeToShare_ShouldShowShareLifeGoalSheet() async {
        let lifeGoal = LifeGoal(
            id: UUID(),
            title: "title",
            finishedAt: Date.createDate(year: 2000, month: 1, day: 1),
            symbolName: "symbolName",
            details: "details"
        )
        let store = TestStore(initialState: LifeGoalsReducer.State()) {
            LifeGoalsReducer()
        }
        
        await store.send(.swipeToShare(lifeGoal)) {
            $0.shareLifeGoal = .init(lifeGoal: lifeGoal)
        }
    }
    
    func testSwipeToShare_ShouldAddToAnalytics() async {
        var eventName = ""
        let lifeGoal = LifeGoal(
            id: UUID(),
            title: "title",
            finishedAt: Date.createDate(year: 2000, month: 1, day: 1),
            symbolName: "symbolName",
            details: "details"
        )
        let store = TestStore(initialState: LifeGoalsReducer.State()) {
            LifeGoalsReducer()
        } withDependencies: {
            $0.analyticsClient.send = { event in
                eventName = event
            }
        }
        store.exhaustivity = .off
        
        await store.send(.swipeToShare(lifeGoal))
        
        XCTAssertEqual(eventName, "life_goals.swipe_to_share")
    }
    
    func testLifeGoalTapped_ShouldShowAddOrEditLifeGoalSheet() async {
        let lifeGoal = LifeGoal(
            id: UUID(),
            title: "title",
            finishedAt: Date.createDate(year: 2023, month: 1, day: 1),
            symbolName: "symbolName",
            details: "details"
        )
        let store = TestStore(initialState: LifeGoalsReducer.State()) {
            LifeGoalsReducer()
        }
        
        await store.send(.lifeGoalTapped(lifeGoal)) {
            $0.addOrEditLifeGoal = .init(
                title: lifeGoal.title,
                details: lifeGoal.details,
                isCompleted: lifeGoal.isCompleted,
                symbolName: lifeGoal.symbolName,
                finishedAt: lifeGoal.finishedAt!,
                lifeGoalToEdit: lifeGoal
            )
        }
    }
}
