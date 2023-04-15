//
//  AddOrEditLifeGoalStore.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 12/04/2023.
//

import Foundation
import ComposableArchitecture


/// A type alias for a store of the `AddOrEditLifeGoalReducer`'s state and action types.
typealias AddOrEditLifeGoalStore = Store<AddOrEditLifeGoalReducer.State, AddOrEditLifeGoalReducer.Action>

/// A reducer that manages the state of the add or edit life goal.
struct AddOrEditLifeGoalReducer: ReducerProtocol {
    
    /// The state of the about the app.
    struct State: Equatable {
        /// The title of the life goal.
        var title = ""
        
        /// The description of the life goal.
        var details = ""
        
         /// Whether the life goal was completed.
        var isCompleted = false
        
        /// The selected SF Symbol for the life goal.
        var symbolName = ""
        
        /// The date when life goal was accomplished.
        var finishedAt = Date.now
        
        /// Whether the life goal is being edited.
        var isEditing = false
        
        /// Whether the date picker is visible.
        var isDatePickerVisible = false
        
        /// The state of date picker.
        var datePicker: DatePickerReducer.State {
            get { .init(date: self.finishedAt, isDatePickerVisible: self.isDatePickerVisible) }
            set {
                self.finishedAt = newValue.date
                self.isDatePickerVisible = newValue.isDatePickerVisible
            }
        }
    }
    
    /// The actions that can be taken on the about the app.
    enum Action: Equatable {
        /// Indicates that title has changed.
        case titleChanged(String)
        /// Indicates that details has changed.
        case detailsChanged(String)
        /// Indicates that is completed flag has changed.
        case isCompletedChanged(Bool)
        /// Indicates that is SF Symbol has changed.
        case symbolNameChanged(String)
        /// Indicates that the date when life goal was accomplished has changed.
        case finishedAtChanged(Date)
        /// The actions that can be taken on the date picker.
        case datePicker(DatePickerReducer.Action)
    }
    
    /// The body of the reducer that processes incoming actions and updates the state accordingly.
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.datePicker, action: /Action.datePicker) {
            DatePickerReducer()
        }
        Reduce { state, action in
            switch action {
            case .titleChanged(let title):
                state.title = title
                return .none
                
            case .detailsChanged(let details):
                state.details = details
                return .none
                
            case .isCompletedChanged(let isCompleted):
                state.isCompleted = isCompleted
                if !isCompleted {
                    state.isDatePickerVisible = false
                }
                return .none
                
            case .symbolNameChanged(let symbolName):
                state.symbolName = symbolName
                return .none
                
            case .finishedAtChanged(let finishedAt):
                state.finishedAt = finishedAt
                return .none
                
            case .datePicker:
                return .none
            }
        }
    }
}
