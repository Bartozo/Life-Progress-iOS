//
//  SettingsStore.swift
//  LifeProgress
//
//  Created by Bartosz Król on 13/03/2023.
//

import Foundation
import ComposableArchitecture

/// A reducer that manages the state of the settings.
@Reducer
struct SettingsReducer {

    /// The state of the settings.
    struct State: Equatable {
        /// The in-app purchases's state.
        var iap = IAPReducer.State()
        
        /// The user's birthday state.
        var birthday = BirthdayReducer.State()
        
        /// The user's life expectancy state.
        var lifeExpectancy = LifeExpectancyReducer.State()
        
        /// The user's weekly notification state.
        var weeklyNotification = WeeklyNotificationReducer.State()
        
        /// The user's theme.
        var theme = ThemeReducer.State()
        
        /// The developer's state.
        var developer = DeveloperReducer.State()
        
        /// The credits state.
        var credits = CreditsReducer.State()
    }
    
    /// The actions that can be taken on the settings.
    enum Action: Equatable {
        /// The actions that can be taken on the in-app purchase.
        case iap(IAPReducer.Action)
        /// The actions that can be taken on the birthday.
        case birthday(BirthdayReducer.Action)
        /// The actions that can be taken on the life expectancy.
        case lifeExpectancy(LifeExpectancyReducer.Action)
        /// The actions that can be taken on the weekly notification.
        case weeklyNotification(WeeklyNotificationReducer.Action)
        /// The actions that can be taken on the theme.
        case theme(ThemeReducer.Action)
        /// The actions that can be taken on the developer.
        case developer(DeveloperReducer.Action)
        /// The actions that can be taken on the credits.
        case credits(CreditsReducer.Action)
    }
    
    /// The body of the reducer that processes incoming actions and updates the state accordingly.
    var body: some Reducer<State, Action> {
        Scope(state: \.iap, action: /Action.iap) {
            IAPReducer()
        }
        Scope(state: \.birthday, action: /Action.birthday) {
            BirthdayReducer()
        }
        Scope(state: \.lifeExpectancy, action: /Action.lifeExpectancy) {
            LifeExpectancyReducer()
        }
        Scope(state: \.weeklyNotification, action: /Action.weeklyNotification) {
            WeeklyNotificationReducer()
        }
        Scope(state: \.theme, action: /Action.theme) {
            ThemeReducer()
        }
        Scope(state: \.developer, action: /Action.developer) {
            DeveloperReducer()
        }
        Scope(state: \.credits, action: /Action.credits) {
            CreditsReducer()
        }
        Reduce { state, action in
            switch action {
            case .iap(_):
                return .none
                
            case .birthday(_):
                return .none
                
            case .lifeExpectancy(_):
                return .none
                
            case .weeklyNotification(_):
                return .none
                
            case .theme(_):
                return .none
                
            case .developer:
                return .none
                
            case .credits:
                return .none
            }
        }
    }
}
