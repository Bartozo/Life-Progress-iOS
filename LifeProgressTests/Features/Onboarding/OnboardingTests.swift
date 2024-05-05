//
//  OnboardingTests.swift
//  LifeProgressTests
//
//  Created by Bartosz Król on 29/07/2023.
//

import XCTest
import ComposableArchitecture

@testable import Life_Progress___Calendar

@MainActor
class OnboardingTests: XCTestCase {
    
    func testGetStartedButtonTapped_ShouldShowAboutScreen() async {
        let store = TestStore(initialState: OnboardingReducer.State()) {
            OnboardingReducer()
        }
        
        await store.send(.getStartedButtonTapped) {
            $0.path = [OnboardingReducer.State.Screen.about]
        }
    }
    
    func testGetStartedButtonTapped_ShouldAddToAnalytics() async {
        var eventName = ""
        let store = TestStore(initialState: OnboardingReducer.State()) {
            OnboardingReducer()
        } withDependencies: {
            $0.analyticsClient.send = { event in
                eventName = event
            }
        }
        store.exhaustivity = .off
        
        await store.send(.getStartedButtonTapped)
        
        XCTAssertEqual(eventName, "onboarding.get_started_button_tapped")
    }
    
    func testContinueButtonTapped_ShouldShowNextScreen() async {
        let store = TestStore(
            initialState: OnboardingReducer.State(
                path: [OnboardingReducer.State.Screen.about]
            )
        ) {
            OnboardingReducer()
        }
        
        await store.send(.continueButtonTapped) {
            $0.path = [
                OnboardingReducer.State.Screen.about,
                OnboardingReducer.State.Screen.birthday
            ]
        }
        
        await store.send(.continueButtonTapped) {
            $0.path = [
                OnboardingReducer.State.Screen.about,
                OnboardingReducer.State.Screen.birthday,
                OnboardingReducer.State.Screen.lifeExpectancy,
            ]
        }
        
        await store.send(.continueButtonTapped) {
            $0.path = [
                OnboardingReducer.State.Screen.about,
                OnboardingReducer.State.Screen.birthday,
                OnboardingReducer.State.Screen.lifeExpectancy,
                OnboardingReducer.State.Screen.notifications,
            ]
        }
        
        await store.send(.continueButtonTapped) {
            $0.path = [
                OnboardingReducer.State.Screen.about,
                OnboardingReducer.State.Screen.birthday,
                OnboardingReducer.State.Screen.lifeExpectancy,
                OnboardingReducer.State.Screen.notifications,
                OnboardingReducer.State.Screen.review,
            ]
        }
        
        await store.send(.continueButtonTapped) {
            $0.path = [
                OnboardingReducer.State.Screen.about,
                OnboardingReducer.State.Screen.birthday,
                OnboardingReducer.State.Screen.lifeExpectancy,
                OnboardingReducer.State.Screen.notifications,
                OnboardingReducer.State.Screen.review,
                OnboardingReducer.State.Screen.completed,
            ]
        }
    }
    
    func testAllowNotificationsButtonTapped_ShouldShowNextScreen() async {
        let store = TestStore(
            initialState: OnboardingReducer.State(
                path: [
                    OnboardingReducer.State.Screen.about,
                    OnboardingReducer.State.Screen.birthday,
                    OnboardingReducer.State.Screen.lifeExpectancy,
                    OnboardingReducer.State.Screen.notifications,
                ]
            )
        ) {
            OnboardingReducer()
        }
        
        await store.send(.allowNotificationsButtonTapped)
        await store.receive(.continueButtonTapped) {
            $0.path = [
                OnboardingReducer.State.Screen.about,
                OnboardingReducer.State.Screen.birthday,
                OnboardingReducer.State.Screen.lifeExpectancy,
                OnboardingReducer.State.Screen.notifications,
                OnboardingReducer.State.Screen.review,
            ]
        }
    }
    
    func testAllowNotificationsButtonTapped_ShouldAddToAnalytics() async {
        var eventName = ""
        let store = TestStore(initialState: OnboardingReducer.State()) {
            OnboardingReducer()
        } withDependencies: {
            $0.analyticsClient.send = { event in
                eventName = event
            }
        }
        store.exhaustivity = .off
        
        await store.send(.allowNotificationsButtonTapped)
        
        XCTAssertEqual(eventName, "onboarding.allow_notifications_button_tapped")
    }
    
    func testSkipNotificationsButtonTapped_ShouldShowNextScreen() async {
        let store = TestStore(
            initialState: OnboardingReducer.State(
                path: [
                    OnboardingReducer.State.Screen.about,
                    OnboardingReducer.State.Screen.birthday,
                    OnboardingReducer.State.Screen.lifeExpectancy,
                    OnboardingReducer.State.Screen.notifications,
                ]
            )
        ) {
            OnboardingReducer()
        }
        
        await store.send(.skipNotificationsButtonTapped) {
            $0.path = [
                OnboardingReducer.State.Screen.about,
                OnboardingReducer.State.Screen.birthday,
                OnboardingReducer.State.Screen.lifeExpectancy,
                OnboardingReducer.State.Screen.notifications,
                OnboardingReducer.State.Screen.completed,
            ]
        }
    }
    
    func testSkipNotificationsButtonTapped_ShouldAddToAnalytics() async {
        var eventName = ""
        let store = TestStore(initialState: OnboardingReducer.State()) {
            OnboardingReducer()
        } withDependencies: {
            $0.analyticsClient.send = { event in
                eventName = event
            }
        }
        store.exhaustivity = .off
        
        await store.send(.skipNotificationsButtonTapped)
        
        XCTAssertEqual(eventName, "onboarding.skip_notifications_button_tapped")
    }
    
    func testStartJourneyButtonTapped_ShouldFinishOnboarding() async {
        var didCompleteOnboarding = false
        let store = TestStore(
            initialState: OnboardingReducer.State(
                path: [
                    OnboardingReducer.State.Screen.about,
                    OnboardingReducer.State.Screen.birthday,
                    OnboardingReducer.State.Screen.lifeExpectancy,
                    OnboardingReducer.State.Screen.notifications,
                    OnboardingReducer.State.Screen.completed
                ]
            )
        ) {
            OnboardingReducer()
        }
        
        await store.send(.startJourneyButtonTapped)  {
            $0.didCompleteOnboarding = true
        }
        await store.receive(.finishOnboarding)
    }
    
    func testStartJourneyButtonTapped_ShouldAddToAnalytics() async {
        var eventName = ""
        let store = TestStore(initialState: OnboardingReducer.State()) {
            OnboardingReducer()
        } withDependencies: {
            $0.analyticsClient.send = { event in
                if eventName.isEmpty {
                    eventName = event
                }
            }
        }
        store.exhaustivity = .off
        
        await store.send(.startJourneyButtonTapped)
        
        XCTAssertEqual(eventName, "onboarding.start_journey_button_tapped")
    }
    
    func testFinishOnboarding_ShouldAddToAnalytics() async {
        var eventName = ""
        let store = TestStore(initialState: OnboardingReducer.State()) {
            OnboardingReducer()
        } withDependencies: {
            $0.analyticsClient.send = { event in
                eventName = event
            }
        }
        store.exhaustivity = .off
        
        await store.send(.finishOnboarding)
        
        XCTAssertEqual(eventName, "onboarding.onboarding_finished")
    }
}
