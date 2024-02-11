//
//  ThemeStore.swift
//  LifeProgress
//
//  Created by Bartosz Król on 15/03/2023.
//

import Foundation
import ComposableArchitecture
import SwiftUI

/// A reducer that manages the state of the theme.
@Reducer
struct ThemeReducer {
    
    /// The state of the theme.
    @ObservableState
    struct State: Equatable {
        /// The user's selected theme.
        var selectedTheme = NSUbiquitousKeyValueStoreHelper.getTheme()
        
        /// A list of themes available in the app.
        let themes = Theme.allCases
    }
    
    /// The actions that can be taken on the theme.
    enum Action: BindableAction, Equatable {
        /// The binding for the theme.
        case binding(BindingAction<State>)
        /// Indicates that the theme has changed.
        case themeChanged(Theme)
        /// Indicates that the view has appeared.
        case onAppear
    }
    
    @Dependency(\.userSettingsClient) var userSettingsClient
    
    @Dependency(\.analyticsClient) var analyticsClient
    
    /// The body of the reducer that processes incoming actions and updates the state accordingly.
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(\.selectedTheme):
                let theme = state.selectedTheme
                analyticsClient.sendWithPayload(
                    "theme.change_theme_tapped", [
                        "selectedTheme": "\(theme)"
                    ]
                )
                return .run { send in
                    await userSettingsClient.updateTheme(theme)
                    await send(.themeChanged(theme))
                }
                
            case .binding:
                return .none
                
            case .themeChanged(let theme):
                state.selectedTheme = theme
                return .none
                
            case .onAppear:
                return .run { send in
                    for await theme in userSettingsClient.themePublisher.values {
                        await send(.themeChanged(theme))
                    }
                }
            }
        }
    }
}
