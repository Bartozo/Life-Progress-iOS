//
//  BirthdayStore.swift
//  LifeProgress
//
//  Created by Bartosz Król on 12/03/2023.
//

import Foundation
import ComposableArchitecture

/// A type alias for a store of the `BirthdayReducer`'s state and action types.
typealias BirthdayStore = Store<BirthdayReducer.State, BirthdayReducer.Action>

/// A reducer that manages the state of the birthday.
struct BirthdayReducer: ReducerProtocol {
    
    /// The state of the birthday.
    struct State: Equatable {
        /// The user's birthday.
        var birthday: Date = UserDefaultsHelper.getBirthday()

        /// Whether the date picker is visible.
        var isDatePickerVisible = false
    }
    
    /// The actions that can be taken on the birthday.
    enum Action: Equatable {
        /// Indicates that the birthday date has changed.
        case birthdayChanged(Date)
        /// Indicates that the date picker visible status has changed.
        case isDatePickerVisibleChanged
        /// Indicates that the view has appeared.
        case onAppear
    }
    
    /// The body of the reducer that processes incoming actions and updates the state accordingly.
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .birthdayChanged(let birthday):
                state.birthday = birthday
                UserDefaultsHelper.saveBirthday(birthday)
                return .none
                
            case .isDatePickerVisibleChanged:
                state.isDatePickerVisible.toggle()
                return .none
                
            case .onAppear:
                state.birthday = UserDefaultsHelper.getBirthday()
                return .none
            }
        }
    }
}
