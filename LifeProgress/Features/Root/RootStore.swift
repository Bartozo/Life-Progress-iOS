//
//  RootStore.swift
//  LifeProgress
//
//  Created by Bartosz Król on 17/03/2023.
//

import Foundation
import ComposableArchitecture

/// A type alias for a store of the `RootReducer`'s state and action types.
typealias RootStore = Store<RootReducer.State, RootReducer.Action>

/// A reducer that manages the state of the root.
struct RootReducer: ReducerProtocol {
    
    /// The state of the root.
    struct State: Equatable {
        /// The life calendar's state.
        var lifeCalendar = LifeCalendarReducer.State()
        
        /// The life goals state.
        var lifeGoals = LifeGoalsReducer.State()

        /// The profile's state.
        var profile = ProfileReducer.State()
        
        /// The current selected tab.
        var selectedTab: Tab? = .lifeCalendar
        
        /// The index of selected tab.
        var selectedTabIndex: Int = 0
        
        /// The path used for NavigationStack.
        var path: [Tab] = []
        
        /// An enumeration that represents the different tabs in an application.
        /// It conforms to `CaseIterable`,`Identifiable` and `Hashable`, allowing for iteration
        /// over all possible cases and providing a unique identifier for each case.
        enum Tab: Int, CaseIterable, Identifiable, Hashable {
            /// Represents life calendar screen
            case lifeCalendar
            /// Represents life goals screen
            case lifeGoals
            /// Represents profile screen
            case profile
            

            /// The unique identifier for each case, derived from the rawValue of the enumeration.
            var id: Int { self.rawValue }
            
            /// A computed property that returns the title associated with tab.
            var title: String {
                switch self {
                case .lifeCalendar:
                    return "Life Calendar"
                case .lifeGoals:
                    return "Life Goals"
                case .profile:
                    return "Profile"
                }
            }
            
            /// A computed property that returns the system image name associated with tab.
            /// These image name correspond to SF Symbols and can be used as icon for the tab.
            var systemImage: String {
                switch self {
                case .lifeCalendar:
                    return "calendar"
                case .lifeGoals:
                    return "flag"
                case .profile:
                    return "person"
                }
            }
        }
    }
    
    /// The actions that can be taken on the root.
    enum Action: Equatable {
        /// The actions that can be taken on the life calendar.
        case lifeCalendar(LifeCalendarReducer.Action)
        /// The actions that can be taken on the life goals.
        case lifeGoals(LifeGoalsReducer.Action)
        /// The actions that can be taken on the profile.
        case profile(ProfileReducer.Action)
        /// Indicates that the tab has changed.
        case tabChanged(State.Tab?)
        /// Indicates that the tab index has changed.
        case tabIndexChanged(Int)
        /// Indicates that path has changed.
        case pathChanged([State.Tab])
    }
    
    /// The body of the reducer that processes incoming actions and updates the state accordingly.
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.lifeCalendar, action: /Action.lifeCalendar) {
            LifeCalendarReducer()
        }
        Scope(state: \.lifeGoals, action: /Action.lifeGoals) {
            LifeGoalsReducer()
        }
        Scope(state: \.profile, action: /Action.profile) {
            ProfileReducer()
        }
        Reduce { state, action in
            switch action {
            case .lifeCalendar(_):
                return .none
                
            case .lifeGoals(_):
                return .none
                
            case .profile(_):
                return .none
                
            case .tabChanged(let tab):
                guard
                    let tab,
                    tab != state.selectedTab
                else {
                    state.path = []
                    return .none
                }
                
                state.selectedTab = tab
                state.selectedTabIndex = tab.rawValue
                state.path = [tab]
                return .none
                
            case .tabIndexChanged(let index):
                guard index != state.selectedTabIndex else { return .none }
                
                state.selectedTabIndex = index
                state.selectedTab = State.Tab(rawValue: index)
                return .none
                
            case .pathChanged(let path):
                state.path = path
                return .none
            }
        }
    }
}
