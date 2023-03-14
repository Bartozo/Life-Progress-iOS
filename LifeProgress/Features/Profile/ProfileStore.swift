//
//  ProfileStore.swift
//  LifeProgress
//
//  Created by Bartosz Król on 13/03/2023.
//

import Foundation
import ComposableArchitecture

/// A type alias for a store of the `ProfileReducer`'s state and action types.
typealias ProfileStore = Store<ProfileReducer.State, ProfileReducer.Action>

struct ProfileReducer: ReducerProtocol {
    
    /// The state of the profile.
    struct State: Equatable {
        /// The user's birthday state.
        var birthday = BirthdayReducer.State()
        
        /// The user's life expectancy state.
        var lifeExpectancy = LifeExpectancyReducer.State()
        
        /// The user's weekly notification state.
        var weeklyNotification = WeeklyNotificationReducer.State()
    }
    
    /// The actions that can be taken on the profile.
    enum Action: Equatable {
        /// The actions that can be taken on the birthday.
        case birthday(BirthdayReducer.Action)
        /// The actions that can be taken on the life expectancy.
        case lifeExpectancy(LifeExpectancyReducer.Action)
        /// The actions that can be taken on the weekly notification.
        case weeklyNotification(WeeklyNotificationReducer.Action)
    }
    
    /// The body of the reducer that processes incoming actions and updates the state accordingly.
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.birthday, action: /Action.birthday) {
            BirthdayReducer()
        }
        Scope(state: \.lifeExpectancy, action: /Action.lifeExpectancy) {
            LifeExpectancyReducer()
        }
        Scope(state: \.weeklyNotification, action: /Action.weeklyNotification) {
            WeeklyNotificationReducer()
        }
    }
}
