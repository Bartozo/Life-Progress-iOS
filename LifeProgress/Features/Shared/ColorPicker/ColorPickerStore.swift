//
//  ColorPickerStore.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 06/08/2023.
//

import SwiftUI
import Foundation
import ComposableArchitecture

/// A reducer that manages the state of the color picker.
struct ColorPickerReducer: Reducer {
    
    /// The state of the color picker.
    struct State: Equatable {
        
        /// Represents the currently selected color.
        var color = Color.red
        
        /// An enumeration representing the colors.
        enum Color: Equatable, CaseIterable, Identifiable {
            case red
            case orange
            case yellow
            case green
            case blue
            case purple
            case pink
            case gray
            
            var id: Color { self }
            
            var colorValue: SwiftUI.Color {
                switch self {
                case .red:
                    return .red
                case .orange:
                    return .orange
                case .yellow:
                    return .yellow
                case .green:
                    return .green
                case .blue:
                    return .blue
                case .purple:
                    return .purple
                case .pink:
                    return .pink
                case .gray:
                    return .gray
                }
            }
        }
    }
    
    /// The actions that can be taken on the color picker.
    enum Action: Equatable {
        /// Indicates that color has changed.
        case colorChanged(State.Color)
    }
    
    /// The body of the reducer that processes incoming actions and updates the state accordingly.
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .colorChanged(let color):
                state.color = color
                return .none
            }
        }
    }
}
