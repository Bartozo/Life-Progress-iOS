//
//  BirthdayTests.swift
//  LifeProgressTests
//
//  Created by Bartosz Król on 17/06/2023.
//

import XCTest
import ComposableArchitecture
import Combine

@testable import Life_Progress___Calendar

@MainActor
class BirthdayTests: XCTestCase {
    
    func testOnAppear_ShouldListenToBirthdayChanges() async {
        let birthdayPublisher = PassthroughSubject<Date, Never>()
        let mainQueue = DispatchQueue.test
        let store = TestStore(initialState: BirthdayReducer.State()) {
            BirthdayReducer()
        } withDependencies: {
            $0.userSettingsClient.birthdayPublisher = birthdayPublisher.eraseToAnyPublisher()
            $0.mainQueue = mainQueue.eraseToAnyScheduler()
        }
        
        // Start a birthday listener
        let task = await store.send(.onAppear)
  
        let firstBirthday = Date.createDate(year: 2000, month: 1, day: 1)
        birthdayPublisher.send(firstBirthday)
        await mainQueue.advance(by: .seconds(1))
        await store.receive(.birthdayChanged(firstBirthday)) {
            $0.birthday = firstBirthday
        }
        
        let secondBirthday = Date.createDate(year: 1990, month: 2, day: 2)
        birthdayPublisher.send(secondBirthday)
        await mainQueue.advance(by: .seconds(1))
        await store.receive(.birthdayChanged(secondBirthday)) {
            $0.birthday = secondBirthday
        }
        
        // Cancel the listener
        await task.cancel()
        
        // Verify that new birthday values are not received after cancellation
        let thirdBirthday = Date.createDate(year: 1980, month: 3, day: 3)
        birthdayPublisher.send(thirdBirthday)
        await mainQueue.advance(by: .seconds(1))
        XCTAssert(store.state.birthday == secondBirthday)
    }

    func testChangeBirthdayTapped_ShouldSaveAndUpdateBirthday() async {
        let initialBirthday = Date.createDate(year: 2000, month: 1, day: 1)
        var birthday = Date()
        let store = TestStore(initialState: BirthdayReducer.State()) {
            BirthdayReducer()
        } withDependencies: {
            $0.userSettingsClient.updateBirthday = { @MainActor newBirthday in
                birthday = newBirthday
            }
        }

        await store.send(.set(\.$birthday, initialBirthday)) {
            $0.birthday = initialBirthday
        }
        
        await store.receive(.birthdayChanged(initialBirthday))

        XCTAssert(birthday == initialBirthday)
    }

    func testBirthdayChanged_ShouldUpdateBirthday() async {
        let birthday = Date.createDate(year: 2000, month: 1, day: 1)
        let store = TestStore(initialState: BirthdayReducer.State()) {
            BirthdayReducer()
        }
        
        await store.send(.birthdayChanged(birthday)) {
            $0.birthday = birthday
        }
    }
    
    func testIsDatePickerVisibleChanged_ShouldShowPicker() async {
        let store = TestStore(initialState: BirthdayReducer.State()) {
            BirthdayReducer()
        }
        
        await store.send(.isDatePickerVisibleChanged) {
            $0.isDatePickerVisible = true
        }
    }
    
    func testIsDatePickerVisibleChanged_ShouldHidePicker() async {
        let store = TestStore(
            initialState: BirthdayReducer.State(isDatePickerVisible: true)
        ) {
            BirthdayReducer()
        }
        
        await store.send(.isDatePickerVisibleChanged) {
            $0.isDatePickerVisible = false
        }
    }
}
