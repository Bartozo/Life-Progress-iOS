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
        var birthday: Date = NSUbiquitousKeyValueStoreHelper.getBirthday()

        /// Whether the date picker is visible.
        var isDatePickerVisible = false
    }
    
    /// The actions that can be taken on the birthday.
    enum Action: Equatable {
        /// Indicates that the date picker was tapped.
        case changeBirthdayTapped(Date)
        /// Indicates that the birthday date has changed.
        case birthdayChanged(Date)
        /// Indicates that the date picker visible status has changed.
        case isDatePickerVisibleChanged
        /// Indicates that the view has appeared.
        case onAppear
    }
    
    @Dependency(\.userSettingsClient) var userSettingsClient
    private enum BirthdayRequestID {}
    
    @Dependency(\.mainQueue) var mainQueue
    
    /// The body of the reducer that processes incoming actions and updates the state accordingly.
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .changeBirthdayTapped(let birthday):
                return .run { send in
                    await userSettingsClient.updateBirthday(birthday)
                    await send(.birthdayChanged(birthday))
                }
                .cancellable(id: BirthdayRequestID.self)
                
            case .birthdayChanged(let birthday):
                state.birthday = birthday
                return .none
                
            case .isDatePickerVisibleChanged:
                state.isDatePickerVisible.toggle()
                return .none
                
            case .onAppear:
                return userSettingsClient
                    .birthdayPublisher
                    .receive(on: mainQueue)
                    .eraseToEffect()
                    .map { Action.birthdayChanged($0) }
                    .cancellable(id: BirthdayRequestID.self)
            }
        }
    }
}
