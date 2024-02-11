//
//  DatePickerTests.swift
//  LifeProgressTests
//
//  Created by Bartosz Król on 18/06/2023.
//

import XCTest
import ComposableArchitecture

@testable import Life_Progress___Calendar

@MainActor
class DatePickerTests: XCTestCase {
    
    func testDateChanged_ShouldUpdateDate() async {
        let store = TestStore(initialState: DatePickerReducer.State()) {
            DatePickerReducer()
        }
        let newDate = Date.createDate(year: 2000, month: 1, day: 1)
        
        await store.send(.set(\.date, newDate)) {
            $0.date = newDate
        }
    }
    
    func testIsDatePickerVisibleChanged_ShouldShowPicker() async {
        let store = TestStore(initialState: DatePickerReducer.State()) {
            DatePickerReducer()
        }
        
        await store.send(.isDatePickerVisibleChanged) {
            $0.isDatePickerVisible = true
        }
    }
    
    func testIsDatePickerVisibleChanged_ShouldHidePicker() async {
        let store = TestStore(initialState: DatePickerReducer.State(isDatePickerVisible: true)) {
            DatePickerReducer()
        }
        
        await store.send(.isDatePickerVisibleChanged) {
            $0.isDatePickerVisible = false
        }
    }
}
