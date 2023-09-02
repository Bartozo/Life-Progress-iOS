//
//  ShareLifeGoalStore.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 02/08/2023.
//

import SwiftUI
import Foundation
import ComposableArchitecture

/// A reducer that manages the state of the share life goal.
struct ShareLifeGoalReducer: Reducer {
    
    /// The state of the share life goal.
    struct State: Equatable {
        /// The user's selected life goal to share.
        var lifeGoal: LifeGoal
        
        /// Represents the currently selected theme.
        var theme = Theme.light
        
        /// Whether the time is visible.
        var isTimeVisible = true
        
        /// Whether the watermark is visible.
        var isWatermarkVisible = true
        
        /// The user's life expectancy state.
        var colorPicker = ColorPickerReducer.State()
        
        /// An enumeration representing the two possible types of themes: light and dark.
        enum Theme: Equatable, CaseIterable {
            case light
            case dark
            
            /// A computed property that returns the title of the theme.
            var title: String {
                switch self {
                case .light:
                    return "Light"
                case .dark:
                    return "Dark"
                }
            }
        }
    }
    
    /// The actions that can be taken on the share life goal.
    enum Action: Equatable {
        /// Indicates that theme has changed.
        case themeChanged(State.Theme)
        /// Indicates that is time visible flag has changed.
        case isTimeVisibleChanged(Bool)
        /// Indicates that is watermark visible flag has changed.
        case isWatermarkVisibleChanged(Bool)
        /// Indicates that close button was tapped.
        case closeButtonTapped
        /// Indicates that share button was tapped.
        case shareButtonTapped
        /// The actions that can be taken on the color picker.
        case colorPicker(ColorPickerReducer.Action)
    }
    
    @Dependency(\.analyticsClient) var analyticsClient
    
    /// The body of the reducer that processes incoming actions and updates the state accordingly.
    var body: some Reducer<State, Action> {
        Scope(state: \.colorPicker, action: /Action.colorPicker) {
            ColorPickerReducer()
        }
        Reduce { state, action in
            switch action {
            case .themeChanged(let theme):
                state.theme = theme
                return .none
                
            case .isTimeVisibleChanged(let isTimeVisible):
                state.isTimeVisible = isTimeVisible
                return .none
                
            case .isWatermarkVisibleChanged(let isWatermarkVisible):
                state.isWatermarkVisible = isWatermarkVisible
                return .none
                
            case .closeButtonTapped:
                return .none
                
            case .shareButtonTapped:
                analyticsClient.send("share_life_goal.share_button_tapped")
                return .none
                
            case .colorPicker:
                return .none
            }
        }
    }
}

