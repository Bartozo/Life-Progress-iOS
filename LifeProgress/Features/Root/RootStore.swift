//
//  RootStore.swift
//  LifeProgress
//
//  Created by Bartosz Król on 17/03/2023.
//

import Foundation
import ComposableArchitecture

/// A type alias for a store of the `RootReducer`'s state and action types.
typealias RootStore = Store<RootReducer.State, RootReducer.Action>

/// A reducer that manages the state of the root.
struct RootReducer: ReducerProtocol {
    
    /// The state of the root.
    struct State: Equatable {
        /// The life calendar's state.
        var lifeCalendar = LifeCalendarReducer.State()

        /// The profile's state.
        var profile = ProfileReducer.State()
    }
    
    /// The actions that can be taken on the root.
    enum Action: Equatable {
        /// The actions that can be taken on the life calendar.
        case lifeCalendar(LifeCalendarReducer.Action)
        /// The actions that can be taken on the profile.
        case profile(ProfileReducer.Action)
    }
    
    /// The body of the reducer that processes incoming actions and updates the state accordingly.
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.lifeCalendar, action: /Action.lifeCalendar) {
            LifeCalendarReducer()
        }
        Scope(state: \.profile, action: /Action.profile) {
            ProfileReducer()
        }
    }
}
