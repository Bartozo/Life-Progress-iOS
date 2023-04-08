//
//  ThemeStore.swift
//  LifeProgress
//
//  Created by Bartosz Król on 15/03/2023.
//

import Foundation
import ComposableArchitecture
import SwiftUI

/// A type alias for a store of the `ThemeReducer`'s state and action types.
typealias ThemeStore = Store<ThemeReducer.State, ThemeReducer.Action>

/// A reducer that manages the state of the theme.
struct ThemeReducer: ReducerProtocol {
    
    /// The state of the theme.
    struct State: Equatable {
        /// The user's selected theme.
        var selectedTheme = UserDefaultsHelper.getTheme()
        
        /// A list of themes available in the app.
        var themes = Theme.allCases
    }
    
    /// The actions that can be taken on the theme.
    enum Action: Equatable {
        /// Indicates that the theme picker was tapped.
        case changeThemeTapped(Theme)
        /// Indicates that the theme has changed.
        case themeChanged(Theme)
        /// Indicates that the view has appeared.
        case onAppear
    }
    
    @Dependency(\.userSettingsClient) var userSettingsClient
    private enum ThemeRequestID {}
    
    @Dependency(\.mainQueue) var mainQueue
    
    /// The body of the reducer that processes incoming actions and updates the state accordingly.
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .changeThemeTapped(let theme):
                return .run { send in
                    await userSettingsClient.updateTheme(theme)
                    await send(.themeChanged(theme))
                }
                .cancellable(id: ThemeRequestID.self)
                
            case .themeChanged(let theme):
                state.selectedTheme = theme
                return .none
                
            case .onAppear:
                return userSettingsClient
                    .themePublisher
                    .receive(on: mainQueue)
                    .eraseToEffect()
                    .map { Action.themeChanged($0) }
                    .cancellable(id: ThemeRequestID.self)
            }
        }
    }
}
