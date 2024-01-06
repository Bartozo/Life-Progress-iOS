//
//  DeveloperStore.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 04/05/2023.
//

import Foundation
import ComposableArchitecture

/// A reducer that manages the state of the developer.
@Reducer
struct DeveloperReducer {
    
    /// The state of the developer.
    struct State: Equatable {
        /// State responsible for showing the heart confetti.
        @BindingState var confetti: Int = 0
    }
    
    /// The actions that can be taken on the developer.
    enum Action: BindableAction, Equatable {
        /// The binding for the developer.
        case binding(BindingAction<State>)
        /// Indicates that the developer button has been tapped.
        case developerButtonTapped
    }
    
    @Dependency(\.analyticsClient) var analyticsClient
    
    /// The body of the reducer that processes incoming actions and updates the state accordingly.
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none
                
            case .developerButtonTapped:
                analyticsClient.send("developer.developer_button_tapped")
                state.confetti += 1
                return .none
            }
        }
    }
}
