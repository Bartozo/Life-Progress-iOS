//
//  AboutTheAppStore.swift
//  LifeProgress
//
//  Created by Bartosz Król on 01/04/2023.
//

import Foundation
import ComposableArchitecture

/// A reducer that manages the state of the about the app.
@Reducer
struct AboutTheAppReducer {
    
    /// The state of the about the app.
    struct State: Equatable {
        /// The user's life information.
        var life: Life
    }
    
    /// The actions that can be taken on the about the app.
    enum Action: Equatable {
        /// Indicates that is about the app sheet should be hidden.
        case closeAboutTheCalendarSheet
    }
    
    @Dependency(\.dismiss) var dismiss
    
    /// The body of the reducer that processes incoming actions and updates the state accordingly.
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .closeAboutTheCalendarSheet:
                return .run { _ in await self.dismiss() }
            }
        }
    }
}
