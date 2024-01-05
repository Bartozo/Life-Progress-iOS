//
//  AddOrEditLifeGoalStore.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 12/04/2023.
//

import Foundation
import ComposableArchitecture

/// A reducer that manages the state of the add or edit life goal.
@Reducer
struct AddOrEditLifeGoalReducer {
    
    /// The state of the about the app.
    struct State: Equatable {
        /// The title of the life goal.
        @BindingState var title = ""
        
        /// The description of the life goal.
        @BindingState var details = ""
        
         /// Whether the life goal was completed.
        @BindingState var isCompleted = false
        
        /// The selected SF Symbol for the life goal. By default set to "trophy"
        var symbolName = "trophy"
        
        /// The date when life goal was accomplished.
        var finishedAt: Date = {
            @Dependency(\.date.now) var now: Date
            return now
        }()
        
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
        
        /// The share life goal's state.
        var shareLifeGoal: ShareLifeGoalReducer.State?
        
        /// Whether the share life goal sheet is visible.
        var isShareLifeGoalSheetVisible = false
    }
    
    /// The actions that can be taken on the about the app.
    enum Action: BindableAction, Equatable {
        /// The binding for the add or edit life goal.
        case binding(BindingAction<State>)
        /// Indicates that the close button was tapped.
        case closeButtonTapped
        /// Indicates that the add button was tapped.
        case addButtonTapped
        /// Indicates that the save button was tapped.
        case saveButtonTapped
        /// Indicates that the share life goal button was tapped.
        case shareLifeGoalButtonTapped
        /// Indicates that is share life goal sheet should be hidden.
        case closeShareLifeGoalSheet
        /// The actions that can be taken on the date picker.
        case datePicker(DatePickerReducer.Action)
        /// The actions that can be taken on the SF Symbol picker.
        case sfSymbolPicker(SFSymbolPickerReducer.Action)
        /// The actions that can be taken on the confetti.
        case confetti(ConfettiReducer.Action)
        /// The actions that can be taken on the share life goal.
        case shareLifeGoal(ShareLifeGoalReducer.Action)
    }
    
    @Dependency(\.date) var date
    
    @Dependency(\.lifeGoalsClient) var lifeGoalsClient
    
    @Dependency(\.mainQueue) var mainQueue
    
    @Dependency(\.analyticsClient) var analyticsClient
    
    /// The body of the reducer that processes incoming actions and updates the state accordingly.
    var body: some Reducer<State, Action> {
        BindingReducer()
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
            case .binding(\.$isCompleted):
                guard state.isCompleted else {
                    state.isDatePickerVisible = false
                    return .none
                }
            
                return .send(.confetti(.showConfetti))
                
            case .binding:
                return .none
                
            case .closeButtonTapped:
                return .none
                
            case .addButtonTapped:
                analyticsClient.send("add_or_edit_life_goal.add_button_tapped")
                return .run { [
                    title = state.title,
                    finishedAt = state.isCompleted ? state.finishedAt : nil,
                    symbolName = state.symbolName,
                    details = state.details
                ] send in
                    let lifeGoal = LifeGoal(
                        id: UUID(),
                        title: title,
                        finishedAt: finishedAt,
                        symbolName: symbolName,
                        details: details
                    )
                    await lifeGoalsClient.createLifeGoal(lifeGoal)
                    await send(.closeButtonTapped)
                }
                
            case .saveButtonTapped:
                analyticsClient.send("add_or_edit_life_goal.save_button_tapped")
                return .run { [
                    title = state.title,
                    finishedAt = state.isCompleted ? state.finishedAt : nil,
                    symbolName = state.symbolName,
                    details = state.details,
                    lifeGoalToEdit = state.lifeGoalToEdit
                ] send in
                    let lifeGoal = LifeGoal(
                        id: lifeGoalToEdit!.id,
                        title: title,
                        finishedAt: finishedAt,
                        symbolName: symbolName,
                        details: details
                    )
                    await lifeGoalsClient.updateLifeGoal(lifeGoal)
                    await send(.closeButtonTapped)
                }
                
            case .shareLifeGoalButtonTapped:
                guard let lifeGoal = state.lifeGoalToEdit else {
                    return .none
                }
                
                analyticsClient.send("add_or_edit_life_goal.share_life_goal_button_tapped")
                state.shareLifeGoal = .init(
                    lifeGoal: LifeGoal(
                        id: lifeGoal.id,
                        title: lifeGoal.title,
                        finishedAt: state.finishedAt,
                        symbolName: lifeGoal.symbolName,
                        details: lifeGoal.details
                    )
                )
                state.isShareLifeGoalSheetVisible = true
                return .none
                
            case .closeShareLifeGoalSheet:
                state.shareLifeGoal = nil
                state.isShareLifeGoalSheetVisible = false
                return .none
                
            case .datePicker:
                return .none
                
            case .sfSymbolPicker:
                return .none
                
            case .confetti:
                return .none
                
            case .shareLifeGoal(let shareLifeGoalAction):
                if shareLifeGoalAction == .closeButtonTapped {
                    state.isShareLifeGoalSheetVisible = false
                }
                return .none
            }
        }
        .ifLet(\.shareLifeGoal, action: /Action.shareLifeGoal) {
            ShareLifeGoalReducer()
        }
    }
}
