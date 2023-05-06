//
//  DeveloperStore.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 04/05/2023.
//

import Foundation
import ComposableArchitecture

/// A type alias for a store of the `DeveloperReducer`'s state and action types.
typealias DeveloperStore = Store<DeveloperReducer.State, DeveloperReducer.Action>

/// A reducer that manages the state of the developer.
struct DeveloperReducer: ReducerProtocol {
    
    /// The state of the developer.
    struct State: Equatable {
        /// State responsible for showing the heart confetti.
        var confetti: Int = 0
    }
    
    /// The actions that can be taken on the developer.
    enum Action: Equatable {
        /// Indicates that the developer button has been tapped.
        case developerButtonTapped
        /// Indicates that the heart confetti has changed.
        case confettiChanged(Int)
    }
    
    @Dependency(\.analyticsClient) var analyticsClient
    
    /// The body of the reducer that processes incoming actions and updates the state accordingly.
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .developerButtonTapped:
                analyticsClient.send("developer.developer_button_tapped")
                state.confetti += 1
                return .none
                
            case .confettiChanged(let confetti):
                state.confetti = confetti
                return .none
            }
        }
    }
}
