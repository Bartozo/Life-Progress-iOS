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
        
        /// The user's filtered life goals.
        var filteredLifeGoals: [LifeGoal] {
            switch listType {
            case .completed:
                return self.lifeGoals.filter { $0.isCompleted }
            case .uncompleted:
                return self.lifeGoals.filter { !$0.isCompleted }
            }
        }
        
        /// Whether the about calendar sheet is visible.
        var listType: ListType = .completed
        
        /// Whether the about calendar sheet is visible.
        var isAddLifeGoalSheetVisible = false
        
        /// The add or edit life goal state.
        var addOrEditLifeGoal: AddOrEditLifeGoalReducer.State?
    }
    
    
    /// The actions that can be taken on the about the app.
    enum Action: Equatable {
        /// Indicates that the view has appeared.
        case onAppear
        /// Indicates that list type has changed.
        case listTypeChanged(ListType)
        /// Indicates that life goals have changed.
        case lifeGoalsChanged([LifeGoal])
        /// Indicates that the add button has been tapped.
        case addButtonTapped
        /// Indicates that is add life goal sheet should be hidden.
        case closeAddLifeGoalSheet
        /// Indicates that the swipe to delete action was performed.
        case swipeToDelete(LifeGoal)
        /// Indicates that the swipe to complete action was performed.
        case swipeToComplete(LifeGoal)
        /// Indicates that the swipe to uncomplete action was performed.
        case swipeToUncomplete(LifeGoal)
        /// Indicates that the life goal has beedn tapped.
        case lifeGoalTapped(LifeGoal)
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
    
    @Dependency(\.lifeGoalsClient) var lifeGoalsClient
    
    @Dependency(\.mainQueue) var mainQueue
    
    /// The body of the reducer that processes incoming actions and updates the state accordingly.
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .task {
                    let lifeGoals = await lifeGoalsClient.fetchLifeGoals()
                    return .lifeGoalsChanged(lifeGoals)
                }
                
            case .listTypeChanged(let listType):
                state.listType = listType
                return .none
                
            case .lifeGoalsChanged(let lifeGoals):
                state.lifeGoals = lifeGoals
                return .none
                
            case .addButtonTapped:
                state.isAddLifeGoalSheetVisible = true
                state.addOrEditLifeGoal = .init()
                return .none
                
            case .closeAddLifeGoalSheet:
                state.isAddLifeGoalSheetVisible = false
                return .none
                
            case .swipeToDelete(let lifeGoal):
                return .task {
                    await lifeGoalsClient.deleteLifeGoal(lifeGoal)
                    return .onAppear
                }
                
            case .swipeToComplete(let lifeGoal):
                let newLifeGoal = LifeGoal(
                    id: lifeGoal.id,
                    title: lifeGoal.title,
                    finishedAt: Date.now,
                    symbolName: lifeGoal.symbolName,
                    details: lifeGoal.details
                )
                return .task {
                    await lifeGoalsClient.updateLifeGoal(newLifeGoal)
                    return .onAppear
                }
                
            case .swipeToUncomplete(let lifeGoal):
                let newLifeGoal = LifeGoal(
                    id: lifeGoal.id,
                    title: lifeGoal.title,
                    finishedAt: nil,
                    symbolName: lifeGoal.symbolName,
                    details: lifeGoal.details
                )
                return .task {
                    await lifeGoalsClient.updateLifeGoal(newLifeGoal)
                    return .onAppear
                }
                
            case .lifeGoalTapped(let lifeGoal):
                state.isAddLifeGoalSheetVisible = true
                state.addOrEditLifeGoal = .init(
                    title: lifeGoal.title,
                    details: lifeGoal.details,
                    isCompleted: lifeGoal.isCompleted,
                    symbolName: lifeGoal.symbolName,
                    finishedAt: lifeGoal.finishedAt ?? Date.now,
                    lifeGoalToEdit: lifeGoal
                )
                return .none
            
            case .addOrEditLifeGoal(let addOrEditLifeGoalAction):
                if (addOrEditLifeGoalAction == .closeButtonTapped) {
                    state.isAddLifeGoalSheetVisible = false
                    return .none
                }
                return .none
            }
        }
        .ifLet(\.addOrEditLifeGoal, action: /Action.addOrEditLifeGoal) {
          AddOrEditLifeGoalReducer()
        }
    }
}
