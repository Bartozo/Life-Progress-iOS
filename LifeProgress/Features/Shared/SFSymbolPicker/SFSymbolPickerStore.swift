//
//  SFSymbolPickerStore.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 16/04/2023.
//

import Foundation
import ComposableArchitecture


/// A type alias for a store of the `SFSymbolPickerReducer`'s state and action types.
typealias SFSymbolPickerStore = Store<SFSymbolPickerReducer.State, SFSymbolPickerReducer.Action>

/// A reducer that manages the state of the SF Symbol picker.
struct SFSymbolPickerReducer: ReducerProtocol {
    
    /// The state of the about the app.
    struct State: Equatable {
        /// The selected SF Symbol for the life goal. By default set to "trophy"
        var symbolName = "trophy"
        
        /// Whether the SF Symbol sheet is visible.
        var isSheetVisible = false
    }
    
    /// The actions that can be taken on the about the app.
    enum Action: Equatable {
        /// Indicates that is SF Symbol has changed.
        case symbolNameChanged(String)
        /// Indicates that the sheet should be visible.
        case showSheet
        /// Indicates that the sheet should be hidden.
        case hideSheet
    }
    
    /// The body of the reducer that processes incoming actions and updates the state accordingly.
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .symbolNameChanged(let symbolName):
                state.symbolName = symbolName
                return .none
                
            case .showSheet:
                state.isSheetVisible = true
                return .none
                
            case .hideSheet:
                state.isSheetVisible = false
                return .none
            }
        }
    }
}
