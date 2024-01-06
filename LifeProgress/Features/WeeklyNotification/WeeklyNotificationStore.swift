//
//  WeeklyNotificationStore.swift
//  LifeProgress
//
//  Created by Bartosz Król on 13/03/2023.
//

import Foundation
import ComposableArchitecture

/// A reducer that manages the state of the weekly notification.
@Reducer
struct WeeklyNotificationReducer {
    
    /// The state of the weekly notification.
    struct State: Equatable {
        /// Whether the weekly notification is enabled
        @BindingState var isWeeklyNotificationEnabled = false
    }
    
    /// The actions that can be taken on the weekly notification.
    enum Action: BindableAction, Equatable {
        /// The binding for the weekly notification.
        case binding(BindingAction<State>)
    }
    
    @Dependency(\.analyticsClient) var analyticsClient
    
    /// The body of the reducer that processes incoming actions and updates the state accordingly.
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(\.$isWeeklyNotificationEnabled):
                NSUbiquitousKeyValueStoreHelper.saveIsWeeklyNotificationEnabled(state.isWeeklyNotificationEnabled)
                analyticsClient.sendWithPayload(
                    "weekly_notification.is_weekly_notification_changed", [
                        "isWeeklyNotificationEnabled": "\(state.isWeeklyNotificationEnabled)"
                    ])
                return .none
                
            case .binding:
                return .none
            }
        }
    }
}
