//
//  OnboardingStore.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 03/05/2023.
//

import Foundation
import ComposableArchitecture
import UserNotifications

/// A reducer that manages the state of the onboarding.
@Reducer
struct OnboardingReducer {
    
    /// The state of the onboarding.
    struct State: Equatable {
        /// The user's birthday state.
        var birthday = BirthdayReducer.State()
        
        /// The user's life expectancy state.
        var lifeExpectancy = LifeExpectancyReducer.State()
        
        /// The path used for NavigationStack.
        @BindingState var path: [Screen] = []
        
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
            /// Represents the review screen
            case review
            /// Represents the completed screen
            case completed
            
            /// The unique identifier for each case, derived from the rawValue of the enumeration.
            var id: Int { self.rawValue }
        }
    }
    
    /// The actions that can be taken on the onboarding.
    enum Action: BindableAction, Equatable {
        /// The binding for the onboarding.
        case binding(BindingAction<State>)
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
        /// Indicates that start journey button has been tapped.
        case startJourneyButtonTapped
        /// Indicates that onboarding is finished.
        case finishOnboarding
    }
    
    @Dependency(\.userSettingsClient) var userSettingsClient
    private enum LifeExpectancyRequestID {}
    
    @Dependency(\.mainQueue) var mainQueue
    
    @Dependency(\.analyticsClient) var analyticsClient
    
    @Dependency(\.notificationsClient) var nofiticationsClient
    
    /// The body of the reducer that processes incoming actions and updates the state accordingly.
    var body: some Reducer<State, Action> {
        BindingReducer()
        Scope(state: \.birthday, action: /Action.birthday) {
            BirthdayReducer()
        }
        Scope(state: \.lifeExpectancy, action: /Action.lifeExpectancy) {
            LifeExpectancyReducer()
        }
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none
                
            case .birthday:
                return .none
                
            case .lifeExpectancy:
                return .none
                
            case .getStartedButtonTapped:
                analyticsClient.send("onboarding.get_started_button_tapped")
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
                
                guard state.path.contains(State.Screen.review) else {
                    state.path.append(State.Screen.review)
                    return .none
                }
                
                guard state.path.contains(State.Screen.completed) else {
                    state.path.append(State.Screen.completed)
                    return .none
                }
                return .none
                
            case .allowNotificationsButtonTapped:
                return .run { send in
                    analyticsClient.send("onboarding.allow_notifications_button_tapped")
                    await nofiticationsClient.requestPermission()
                    await send(.continueButtonTapped)
                }
                
            case .skipNotificationsButtonTapped:
                state.path.append(State.Screen.completed)
                analyticsClient.send("onboarding.skip_notifications_button_tapped")
                return .none
                
            case .startJourneyButtonTapped:
                return .run { send in
                    await self.userSettingsClient.updateDidCompleteOnboarding(true)
                    analyticsClient.send("onboarding.start_journey_button_tapped")
                    await send(.finishOnboarding)
                }
                
            case .finishOnboarding:
                analyticsClient.send("onboarding.onboarding_finished")
                return .none
            }
        }
    }
}
