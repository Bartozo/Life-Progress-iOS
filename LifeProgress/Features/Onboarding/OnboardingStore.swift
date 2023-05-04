//
//  OnboardingStore.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 03/05/2023.
//

import Foundation
import ComposableArchitecture
import UserNotifications

/// A type alias for a store of the `OnboardingReducer`'s state and action types.
typealias OnboardingStore = Store<OnboardingReducer.State, OnboardingReducer.Action>

/// A reducer that manages the state of the onboarding.
struct OnboardingReducer: ReducerProtocol {
    
    /// The state of the onboarding.
    struct State: Equatable {
        /// The user's birthday state.
        var birthday = BirthdayReducer.State()
        
        /// The user's life expectancy state.
        var lifeExpectancy = LifeExpectancyReducer.State()
        
        /// The path used for NavigationStack.
        var path: [Screen] = []
        
        /// An enumeration that represents the different screens in an onboarding flow.
        /// It conforms to `CaseIterable`,`Identifiable` and `Hashable`, allowing for iteration
        /// over all possible cases and providing a unique identifier for each case.
        enum Screen: Int, CaseIterable, Identifiable, Hashable {
            /// Represents the about screen
            case about
            /// Represents the birthday screen
            case birthday
            /// Represents the life expectancy screen
            case lifeExpectancy
            /// Represents the notifications screen
            case notifications
            /// Represents the completed screen
            case completed
            
            /// The unique identifier for each case, derived from the rawValue of the enumeration.
            var id: Int { self.rawValue }
        }
    }
    
    /// The actions that can be taken on the onboarding.
    enum Action: Equatable {
        /// The actions that can be taken on the birthday.
        case birthday(BirthdayReducer.Action)
        /// The actions that can be taken on the life expectancy.
        case lifeExpectancy(LifeExpectancyReducer.Action)
        /// Indicates that the get started button has been tapped.
        case getStartedButtonTapped
        /// Indicates that the continue button has been tapped.
        case continueButtonTapped
        /// Indicates that the allow notifications button has been tapped.
        case allowNotificationsButtonTapped
        /// Indicates that the skip notifications button has been tapped.
        case skipNotificationsButtonTapped
        /// Indicates that path has changed.
        case pathChanged([State.Screen])
        /// Indicates that start journey button has been tapped.
        case startJourneyButtonTapped
        /// Indicates that onboarding is finished.
        case finishOnboarding
    }
    
    @Dependency(\.userSettingsClient) var userSettingsClient
    private enum LifeExpectancyRequestID {}
    
    @Dependency(\.mainQueue) var mainQueue
    
    private enum CancelID {}
    
    /// The body of the reducer that processes incoming actions and updates the state accordingly.
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.birthday, action: /Action.birthday) {
            BirthdayReducer()
        }
        Scope(state: \.lifeExpectancy, action: /Action.lifeExpectancy) {
            LifeExpectancyReducer()
        }
        Reduce { state, action in
            switch action {
            case .birthday:
                return .none
                
            case .lifeExpectancy:
                return .none
                
            case .getStartedButtonTapped:
                state.path.append(State.Screen.about)
                return .none
                
            case .continueButtonTapped:
                guard state.path.contains(State.Screen.birthday) else {
                    state.path.append(State.Screen.birthday)
                    return .none
                }
                
                guard state.path.contains(State.Screen.lifeExpectancy) else {
                    state.path.append(State.Screen.lifeExpectancy)
                    return .none
                }
                
                guard state.path.contains(State.Screen.notifications) else {
                    state.path.append(State.Screen.notifications)
                    return .none
                }
                
                guard state.path.contains(State.Screen.completed) else {
                    state.path.append(State.Screen.completed)
                    return .none
                }
                return .none
                
            case .allowNotificationsButtonTapped:
                return .task {
                    let notificationCenter = UNUserNotificationCenter.current()
                    try await notificationCenter.requestAuthorization(options: [.alert, .badge, .sound])
                    return .continueButtonTapped
                }
                .cancellable(id: CancelID.self)
                
            case .skipNotificationsButtonTapped:
                state.path.append(State.Screen.completed)
                return .none
                
            case .pathChanged(let path):
                state.path = path
                return .none
                
            case .startJourneyButtonTapped:
                return .task {
                    await self.userSettingsClient.updateDidCompleteOnboarding(true)
                    return .finishOnboarding
                }
                .cancellable(id: CancelID.self)
                
            case .finishOnboarding:
                return .none
            }
        }
    }
}


