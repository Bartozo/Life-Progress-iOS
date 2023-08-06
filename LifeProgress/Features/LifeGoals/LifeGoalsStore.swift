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
        /// The in-app purchases's state.
        var iap = IAPReducer.State()
        
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
        
        /// Represents the currently selected list type.
        var listType: ListType = .uncompleted
        
        /// Whether the about calendar sheet is visible.
        var isAddLifeGoalSheetVisible = false
        
        /// The confetti's state.
        var confetti = ConfettiReducer.State()
        
        /// The add or edit life goal's state.
        var addOrEditLifeGoal: AddOrEditLifeGoalReducer.State?
        
        /// The share life goal's state.
        var shareLifeGoal: ShareLifeGoalReducer.State?
        
        /// Whether the share life goal sheet is visible.
        var isShareLifeGoalSheetVisible = false
    }
    
    
    /// The actions that can be taken on the about the app.
    enum Action: Equatable {
        /// The actions that can be taken on the in-app purchase.
        case iap(IAPReducer.Action)
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
        /// Indicates that is share life goal sheet should be hidden.
        case closeShareLifeGoalSheet
        /// Indicates that the swipe to delete action was performed.
        case swipeToDelete(LifeGoal)
        /// Indicates that the swipe to complete action was performed.
        case swipeToComplete(LifeGoal)
        /// Indicates that the swipe to uncomplete action was performed.
        case swipeToUncomplete(LifeGoal)
        /// Indicates that the swipe to share action was performed.
        case swipeToShare(LifeGoal)
        /// Indicates that the life goal has been tapped.
        case lifeGoalTapped(LifeGoal)
        /// The actions that can be taken on the confetti.
        case confetti(ConfettiReducer.Action)
        /// The actions that can be taken on the add or edit life goal.
        case addOrEditLifeGoal(AddOrEditLifeGoalReducer.Action)
        /// The actions that can be taken on the share life goal.
        case shareLifeGoal(ShareLifeGoalReducer.Action)
    }
    
    /// An enumeration representing the two possible types of calendars:
    ///  one for the current year, and one for the entire life.
    enum ListType: Equatable, CaseIterable {
        case uncompleted
        case completed
        
        var title: String {
            switch self {
            case .uncompleted:
                return "Uncompleted"
            case .completed:
                return "Completed"
            }
        }
    }
    
    @Dependency(\.date.now) var now
    
    @Dependency(\.lifeGoalsClient) var lifeGoalsClient
    private enum LifeGoalsRequestID {}
    
    @Dependency(\.analyticsClient) var analyticsClient
    
    /// The body of the reducer that processes incoming actions and updates the state accordingly.
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.iap, action: /Action.iap) {
            IAPReducer()
        }
        Scope(state: \.confetti, action: /Action.confetti) {
            ConfettiReducer()
        }
        Reduce { state, action in
            switch action {
            case .iap(_):
                return .none
                
            case .onAppear:
                return .task {
                    let lifeGoals = await lifeGoalsClient.fetchLifeGoals()
                    return .lifeGoalsChanged(lifeGoals)
                }
                .cancellable(id: LifeGoalsRequestID.self)
                
            case .listTypeChanged(let listType):
                state.listType = listType
                return .none
                
            case .lifeGoalsChanged(let lifeGoals):
                state.lifeGoals = lifeGoals
                return .none
                
            case .addButtonTapped:
                analyticsClient.send("life_goals.add_button_tapped")
                if !state.iap.hasUnlockedPremium && state.lifeGoals.count >= 3 {
                    state.iap.isSheetVisible = true
                } else {
                    state.isAddLifeGoalSheetVisible = true
                    state.addOrEditLifeGoal = .init()
                }
                return .none
                
            case .closeAddLifeGoalSheet:
                state.isAddLifeGoalSheetVisible = false
                return .none
                
            case .closeShareLifeGoalSheet:
                state.isShareLifeGoalSheetVisible = false
                state.shareLifeGoal = nil
                return .none
                
            case .swipeToDelete(let lifeGoal):
                analyticsClient.send("life_goals.swipe_to_delete")
                return .task {
                    await lifeGoalsClient.deleteLifeGoal(lifeGoal)
                    return .onAppear
                }
                
            case .swipeToComplete(let lifeGoal):
                analyticsClient.send("life_goals.swipe_to_complete")
                let newLifeGoal = LifeGoal(
                    id: lifeGoal.id,
                    title: lifeGoal.title,
                    finishedAt: now,
                    symbolName: lifeGoal.symbolName,
                    details: lifeGoal.details
                )
                return .concatenate([
                    .task {
                        await lifeGoalsClient.updateLifeGoal(newLifeGoal)
                        return .onAppear
                    },
                    .send(.confetti(.showConfetti))
                ])
                
            case .swipeToUncomplete(let lifeGoal):
                analyticsClient.send("life_goals.swipe_to_uncomplete")
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
                
            case .swipeToShare(let lifeGoal):
                state.shareLifeGoal = .init(lifeGoal: lifeGoal)
                state.isShareLifeGoalSheetVisible = true
                return .none
                
            case .lifeGoalTapped(let lifeGoal):
                state.isAddLifeGoalSheetVisible = true
                state.addOrEditLifeGoal = .init(
                    title: lifeGoal.title,
                    details: lifeGoal.details,
                    isCompleted: lifeGoal.isCompleted,
                    symbolName: lifeGoal.symbolName,
                    finishedAt: lifeGoal.finishedAt ?? now,
                    lifeGoalToEdit: lifeGoal
                )
                return .none
            
            case .addOrEditLifeGoal(let addOrEditLifeGoalAction):
                if addOrEditLifeGoalAction == .closeButtonTapped {
                    state.isAddLifeGoalSheetVisible = false
                    return .send(.onAppear)
                }
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
        .ifLet(\.addOrEditLifeGoal, action: /Action.addOrEditLifeGoal) {
            AddOrEditLifeGoalReducer()
        }
        .ifLet(\.shareLifeGoal, action: /Action.shareLifeGoal) {
            ShareLifeGoalReducer()
        }
    }
}
