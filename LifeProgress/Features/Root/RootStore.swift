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
        /// The user's theme.
        var theme = ThemeReducer.State()
        /// The profile's state.
        var profile = ProfileReducer.State()
    }
    
    /// The actions that can be taken on the root.
    enum Action: Equatable {
        /// The actions that can be taken on the theme.
        case theme(ThemeReducer.Action)
        /// The actions that can be taken on the profile.
        case profile(ProfileReducer.Action)
    }
    
    /// The body of the reducer that processes incoming actions and updates the state accordingly.
    var body: some ReducerProtocol<State, Action> {
//        Scope(state: \.theme, action: /Action.theme) {
//            ThemeReducer()
//        }
        Scope(state: \.profile, action: /Action.profile) {
            ProfileReducer()
        }
        Reduce { state, action in
            switch action {
            case .theme(_):
                print("NOWE THEME")
                return .none
            case .profile(_):
                return .none
            }
        }
    }
}
