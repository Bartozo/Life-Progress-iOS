//
//  DatePickerStore.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 15/04/2023.
//

import Foundation
import ComposableArchitecture

/// A reducer that manages the state of the date picker.
struct DatePickerReducer: Reducer {
    
    /// The state of the date picker.
    struct State: Equatable {
        /// The selected date.
        var date = Date.now

        /// Whether the date picker is visible.
        var isDatePickerVisible = false
    }
    
    /// The actions that can be taken on the date picker.
    enum Action: Equatable {
        /// Indicates that the date has changed.
        case dateChanged(Date)
        /// Indicates that the date picker visible status has changed.
        case isDatePickerVisibleChanged
    }
    
    /// The body of the reducer that processes incoming actions and updates the state accordingly.
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .dateChanged(let date):
                state.date = date
                return .none
                
            case .isDatePickerVisibleChanged:
                state.isDatePickerVisible.toggle()
                return .none
            }
        }
    }
}

