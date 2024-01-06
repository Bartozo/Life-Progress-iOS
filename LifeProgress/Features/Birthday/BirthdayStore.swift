//
//  BirthdayStore.swift
//  LifeProgress
//
//  Created by Bartosz Król on 12/03/2023.
//

import Foundation
import ComposableArchitecture

/// A reducer that manages the state of the birthday.
@Reducer
struct BirthdayReducer {
    
    /// The state of the birthday.
    struct State: Equatable {
        /// The user's birthday.
        @BindingState var birthday: Date = NSUbiquitousKeyValueStoreHelper.getBirthday()

        /// Whether the date picker is visible.
        var isDatePickerVisible = false
    }
    
    /// The actions that can be taken on the birthday.
    enum Action: BindableAction, Equatable {
        /// The binding for the birthday.
        case binding(BindingAction<State>)
        /// Indicates that the birthday date has changed.
        case birthdayChanged(Date)
        /// Indicates that the date picker visible status has changed.
        case isDatePickerVisibleChanged
        /// Indicates that the view has appeared.
        case onAppear
    }
    
    @Dependency(\.userSettingsClient) var userSettingsClient
    
    /// The body of the reducer that processes incoming actions and updates the state accordingly.
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .binding(\.$birthday):
                let birthday = state.birthday
                return .run { send in
                    await userSettingsClient.updateBirthday(birthday)
                    await send(.birthdayChanged(birthday))
                }
                
            case .binding:
                return .none
                
            case .birthdayChanged(let birthday):
                state.birthday = birthday
                return .none
                
            case .isDatePickerVisibleChanged:
                state.isDatePickerVisible.toggle()
                return .none
                
            case .onAppear:
                return .run { send in
                    for await birthday in userSettingsClient.birthdayPublisher.values {
                        await send(.birthdayChanged(birthday))
                    }
                }
            }
        }
    }
}
