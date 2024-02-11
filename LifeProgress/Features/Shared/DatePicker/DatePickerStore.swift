//
//  DatePickerStore.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 15/04/2023.
//

import Foundation
import ComposableArchitecture

/// A reducer that manages the state of the date picker.
@Reducer
struct DatePickerReducer {
    
    /// The state of the date picker.
    @ObservableState
    struct State: Equatable {
        /// The selected date.
        var date = Date.now

        /// Whether the date picker is visible.
        var isDatePickerVisible = false
    }
    
    /// The actions that can be taken on the date picker.
    enum Action: BindableAction, Equatable {
        /// The binding for the date picker.
        case binding(BindingAction<State>)
        /// Indicates that the date picker visible status has changed.
        case isDatePickerVisibleChanged
    }
    
    /// The body of the reducer that processes incoming actions and updates the state accordingly.
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none
                
            case .isDatePickerVisibleChanged:
                state.isDatePickerVisible.toggle()
                return .none
            }
        }
    }
}

