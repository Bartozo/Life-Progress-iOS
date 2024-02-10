//
//  SFSymbolPickerStore.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 16/04/2023.
//

import Foundation
import ComposableArchitecture

/// A reducer that manages the state of the SF Symbol picker.
@Reducer
struct SFSymbolPickerReducer {
    
    /// The state of the about the app.
    @ObservableState
    struct State: Equatable {
        /// The selected SF Symbol for the life goal. By default set to "trophy"
        var symbolName = "trophy"
        
        /// Whether the SF Symbol sheet is visible.
        var isSheetVisible = false
    }
    
    /// The actions that can be taken on the about the app.
    enum Action: BindableAction, Equatable {
        /// The binding for the SF Symbol Picker.
        case binding(BindingAction<State>)
        /// Indicates that the sheet should be visible.
        case showSheet
    }
    
    /// The body of the reducer that processes incoming actions and updates the state accordingly.
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none
                
            case .showSheet:
                state.isSheetVisible = true
                return .none
            }
        }
    }
}
