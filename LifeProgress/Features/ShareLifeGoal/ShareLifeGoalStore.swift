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
@Reducer
struct ShareLifeGoalReducer {
    
    /// The state of the share life goal.
    struct State: Equatable {
        /// The user's selected life goal to share.
        var lifeGoal: LifeGoal
        
        /// Represents the currently selected theme.
        @BindingState var theme = Theme.light
        
        /// Whether the time is visible.
        @BindingState var isTimeVisible = true
        
        /// Whether the watermark is visible.
        @BindingState var isWatermarkVisible = true
        
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
    enum Action: BindableAction, Equatable {
        /// The binding for the share life goal.
        case binding(BindingAction<State>)
        /// Indicates that close button was tapped.
        case closeButtonTapped
        /// Indicates that share button was tapped.
        case shareButtonTapped
        /// The actions that can be taken on the color picker.
        case colorPicker(ColorPickerReducer.Action)
    }
    
    @Dependency(\.analyticsClient) var analyticsClient
    
    @Dependency(\.dismiss) var dismiss
    
    /// The body of the reducer that processes incoming actions and updates the state accordingly.
    var body: some Reducer<State, Action> {
        BindingReducer()
        Scope(state: \.colorPicker, action: /Action.colorPicker) {
            ColorPickerReducer()
        }
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none
                
            case .closeButtonTapped:
                return .run { _ in await self.dismiss() }
                
            case .shareButtonTapped:
                analyticsClient.send("share_life_goal.share_button_tapped")
                return .none
                
            case .colorPicker:
                return .none
            }
        }
    }
}

