//
//  ConfettiStore.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 01/05/2023.
//

import Foundation
import ComposableArchitecture

/// A reducer that manages the state of the confetti.
struct ConfettiReducer: Reducer {
    
    /// The state of the confetti.
    struct State: Equatable {
        /// State responsible for showing the confetti.
        var confetti: Int = 0
    }
    
    /// The actions that can be taken on the confetti.
    enum Action: Equatable {
        /// Indicates that the confetti should be spawned.
        case showConfetti
        /// Indicates that the confetti has changed.
        case confettiChanged(Int)
    }
    
    @Dependency(\.analyticsClient) var analyticsClient
    
    /// The body of the reducer that processes incoming actions and updates the state accordingly.
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .showConfetti:
                analyticsClient.send("confetti.show_confetti")
                state.confetti += 1
                return .none
                
            case .confettiChanged(let confetti):
                state.confetti = confetti
                return .none
            }
        }
    }
}
