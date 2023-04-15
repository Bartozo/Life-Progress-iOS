//
//  LifeGoalsStore.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 11/04/2023.
//

import Foundation
import ComposableArchitecture


/// A type alias for a store of the `LifeGoalsReducer`'s state and action types.
typealias LifeGoalsStore = Store<LifeGoalsReducer.State, LifeGoalsReducer.Action>

/// A reducer that manages the state of the about the app.
struct LifeGoalsReducer: ReducerProtocol {
    
    /// The state of the about the app.
    struct State: Equatable {
        /// The user's life goals.
        var lifeGoals: [LifeGoal] = []
        
        /// Whether the about calendar sheet is visible.
        var listType: ListType = .completed
        
        /// Whether the about calendar sheet is visible.
        var isAddLifeGoalSheetVisible = false
        
        /// The add or edit life goal state.
        var addOrEditLifeGoal: AddOrEditLifeGoalReducer.State?
    }
    
    /// The actions that can be taken on the about the app.
    enum Action: Equatable {
        /// Indicates that is about the app sheet should be hidden.
        case listTypeChanged(ListType)
        /// Indicates that the add button has been tapped.
        case addButtonTapped
        /// Indicates that is add life goal sheet should be hidden.
        case closeAddLifeGoalSheet
        /// The actions that can be taken on the add or edit life goal.
        case addOrEditLifeGoal(AddOrEditLifeGoalReducer.Action)
    }
    
    /// An enumeration representing the two possible types of calendars:
    ///  one for the current year, and one for the entire life.
    enum ListType: Equatable, CaseIterable {
        case completed
        case uncompleted
        
        var title: String {
            switch self {
            case .completed:
                return "Completed"
            case .uncompleted:
                return "Uncompleted"
            }
        }
    }
    
    /// The body of the reducer that processes incoming actions and updates the state accordingly.
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .listTypeChanged(let listType):
                state.listType = listType
                return .none
                
            case .addButtonTapped:
                state.isAddLifeGoalSheetVisible = true
                state.addOrEditLifeGoal = .init()
                return .none
                
            case .closeAddLifeGoalSheet:
                state.isAddLifeGoalSheetVisible = false
                return .none
                
            case .addOrEditLifeGoal:
                return .none
            }
        }
        .ifLet(\.addOrEditLifeGoal, action: /Action.addOrEditLifeGoal) {
          AddOrEditLifeGoalReducer()
        }
    }
}
