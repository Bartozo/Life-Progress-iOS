//
//  RootStore.swift
//  LifeProgress
//
//  Created by Bartosz Król on 17/03/2023.
//

import Foundation
import ComposableArchitecture

/// A reducer that manages the state of the root.
@Reducer
struct RootReducer {
    
    /// The state of the root.
    @ObservableState
    struct State: Equatable {
        /// The onboarding's state.
        var onboarding = OnboardingReducer.State()
        
        /// The life calendar's state.
        var lifeCalendar = LifeCalendarReducer.State()
        
        /// The life goals state.
        var lifeGoals = LifeGoalsReducer.State()
        
        /// The settings's state.
        var settings = SettingsReducer.State()
        
        /// The current selected tab.
        var selectedTab: Tab? = .lifeCalendar
        
        /// The index of selected tab.
        var selectedTabIndex: Int = 0
        
        /// Whether the user has completed the onboarding flow.
        @Shared(.didCompleteOnboarding) var didCompleteOnboarding
        
        /// Whether the weekly notification was scheduled.
        @Shared(.didScheduleWeeklyNotification) var didScheduleWeeklyNotification
        
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
            /// Represents settings screen
            case settings
            
            
            /// The unique identifier for each case, derived from the rawValue of the enumeration.
            var id: Int { self.rawValue }
            
            /// A computed property that returns the title associated with tab.
            var title: String {
                switch self {
                case .lifeCalendar:
                    return "Life Calendar"
                case .lifeGoals:
                    return "Life Goals"
                case .settings:
                    return "Settings"
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
                case .settings:
                    return "gear"
                }
            }
        }
    }
    
    /// The actions that can be taken on the root.
    enum Action: BindableAction, Equatable {
        /// The binding for the root.
        case binding(BindingAction<State>)
        /// Indicates that the did schedule weekly notification has changed.
        case didScheduleWeeklyNotificationChanged(Bool)
        /// The actions that can be taken on the onboarding.
        case onboarding(OnboardingReducer.Action)
        /// The actions that can be taken on the life calendar.
        case lifeCalendar(LifeCalendarReducer.Action)
        /// The actions that can be taken on the life goals.
        case lifeGoals(LifeGoalsReducer.Action)
        /// The actions that can be taken on the settings.
        case settings(SettingsReducer.Action)
    }
    
    /// The body of the reducer that processes incoming actions and updates the state accordingly.
    var body: some Reducer<State, Action> {
        BindingReducer()
        Scope(state: \.onboarding, action: \.onboarding) {
            OnboardingReducer()
        }
        Scope(state: \.lifeCalendar, action: \.lifeCalendar) {
            LifeCalendarReducer()
        }
        Scope(state: \.lifeGoals, action: \.lifeGoals) {
            LifeGoalsReducer()
        }
        Scope(state: \.settings, action: \.settings) {
            SettingsReducer()
        }
        Reduce { state, action in
            switch action {
            case .binding(\.selectedTab):
                guard
                    let tab = state.selectedTab
                else {
                    state.path = []
                    return .none
                }
                
                state.selectedTabIndex = tab.rawValue
                state.path = [tab]
                return .none
                
            case .binding(\.selectedTabIndex):
                state.selectedTab = State.Tab(rawValue: state.selectedTabIndex)
                return .none
                
            case .binding:
                return .none
                
            case .didScheduleWeeklyNotificationChanged(let didScheduleWeeklyNotification):
                state.didScheduleWeeklyNotification = didScheduleWeeklyNotification
                return .none
                
            case .onboarding(let onboardingAction):
                if onboardingAction == .finishOnboarding {
                    state.didCompleteOnboarding = true
                }
                return .none
                
            case .lifeCalendar(_):
                return .none
                
            case .lifeGoals(_):
                return .none
                
            case .settings(_):
                return .none
            }
        }
    }
}
