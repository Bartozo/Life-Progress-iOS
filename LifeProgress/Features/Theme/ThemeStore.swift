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
struct ThemeReducer: Reducer {
    
    /// The state of the theme.
    struct State: Equatable {
        /// The user's selected theme.
        var selectedTheme = NSUbiquitousKeyValueStoreHelper.getTheme()
        
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
    
    @Dependency(\.mainQueue) var mainQueue
    
    @Dependency(\.analyticsClient) var analyticsClient
    
    /// The body of the reducer that processes incoming actions and updates the state accordingly.
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .changeThemeTapped(let theme):
                analyticsClient.sendWithPayload(
                    "theme.change_theme_tapped", [
                        "selectedTheme": "\(theme)"
                    ]
                )
                return .run { send in
                    await userSettingsClient.updateTheme(theme)
                    await send(.themeChanged(theme))
                }
                
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
