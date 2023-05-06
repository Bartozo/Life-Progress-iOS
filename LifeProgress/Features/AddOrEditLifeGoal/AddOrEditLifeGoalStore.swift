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
        
        /// The selected SF Symbol for the life goal. By default set to "trophy"
        var symbolName = "trophy"
        
        /// The date when life goal was accomplished.
        var finishedAt = Date.now
        
        /// Whether the life goal is being edited.
        var isEditing: Bool {
            return lifeGoalToEdit != nil
        }
        
        /// Whether the date picker is visible.
        var isDatePickerVisible = false
        
        /// The life goal to edit.
        var lifeGoalToEdit: LifeGoal?
        
        /// The state of date picker.
        var datePicker: DatePickerReducer.State {
            get { .init(date: self.finishedAt, isDatePickerVisible: self.isDatePickerVisible) }
            set {
                self.finishedAt = newValue.date
                self.isDatePickerVisible = newValue.isDatePickerVisible
            }
        }
        
        /// Whether the SF Symbol picker is visible.
        var isSFSymbolPickerVisible = false
        
        /// The state of SF Symbol picker.
        var sfSymbolPicker: SFSymbolPickerReducer.State {
            get { .init(symbolName: self.symbolName, isSheetVisible: self.isSFSymbolPickerVisible) }
            set {
                self.symbolName = newValue.symbolName
                self.isSFSymbolPickerVisible = newValue.isSheetVisible
            }
        }
        
        /// The confetti's state.
        var confetti = ConfettiReducer.State()
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
        /// Indicates that the close button was tapped.
        case closeButtonTapped
        /// Indicates that the add button was tapped.
        case addButtonTapped
        /// Indicates that the save button was tapped.
        case saveButtonTapped
        /// The actions that can be taken on the date picker.
        case datePicker(DatePickerReducer.Action)
        /// The actions that can be taken on the SF Symbol picker.
        case sfSymbolPicker(SFSymbolPickerReducer.Action)
        /// The actions that can be taken on the confetti.
        case confetti(ConfettiReducer.Action)
    }
    
    @Dependency(\.lifeGoalsClient) var lifeGoalsClient
    private enum LifeExpectancyRequestID {}
    
    @Dependency(\.mainQueue) var mainQueue
    
    @Dependency(\.analyticsClient) var analyticsClient
    
    /// The body of the reducer that processes incoming actions and updates the state accordingly.
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.datePicker, action: /Action.datePicker) {
            DatePickerReducer()
        }
        Scope(state: \.sfSymbolPicker, action: /Action.sfSymbolPicker) {
            SFSymbolPickerReducer()
        }
        Scope(state: \.confetti, action: /Action.confetti) {
            ConfettiReducer()
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
                guard isCompleted else {
                    state.isDatePickerVisible = false
                    return .none
                }
            
                return .send(.confetti(.showConfetti))
                
            case .symbolNameChanged(let symbolName):
                state.symbolName = symbolName
                return .none
                
            case .finishedAtChanged(let finishedAt):
                state.finishedAt = finishedAt
                return .none
                
            case .closeButtonTapped:
                return .none
                
            case .addButtonTapped:
                analyticsClient.send("add_or_edit_life_goal.add_button_tapped")
                return .task { [
                    title = state.title,
                    finishedAt = state.isCompleted ? state.finishedAt : nil,
                    symbolName = state.symbolName,
                    details = state.details
                ] in
                    let lifeGoal = LifeGoal(
                        id: UUID(),
                        title: title,
                        finishedAt: finishedAt,
                        symbolName: symbolName,
                        details: details
                    )
                    await lifeGoalsClient.createLifeGoal(lifeGoal)
                    return .closeButtonTapped
                }
                
            case .saveButtonTapped:
                analyticsClient.send("add_or_edit_life_goal.save_button_tapped")
                return .task { [
                    title = state.title,
                    finishedAt = state.isCompleted ? state.finishedAt : nil,
                    symbolName = state.symbolName,
                    details = state.details,
                    lifeGoalToEdit = state.lifeGoalToEdit
                ] in
                    let lifeGoal = LifeGoal(
                        id: lifeGoalToEdit!.id,
                        title: title,
                        finishedAt: finishedAt,
                        symbolName: symbolName,
                        details: details
                    )
                    await lifeGoalsClient.updateLifeGoal(lifeGoal)
                    return .closeButtonTapped
                }
                
            case .datePicker:
                return .none
                
            case .sfSymbolPicker:
                return .none
                
            case .confetti:
                return .none
            }
        }
    }
}
