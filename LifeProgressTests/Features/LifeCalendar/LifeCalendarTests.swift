//
//  LifeCalendarTests.swift
//  LifeProgressTests
//
//  Created by Bartosz Król on 29/07/2023.
//

import XCTest
import ComposableArchitecture
import Combine

@testable import Life_Progress___Calendar

@MainActor
class LifeCalendarTests: XCTestCase {
    
    func testOnAppear_ShouldListenToBirthdayAndLifeExpectancyChanges() async {
        let birthdayPublisher = PassthroughSubject<Date, Never>()
        let lifeExpectancyPublisher = PassthroughSubject<Int, Never>()
        let mainQueue = DispatchQueue.test
        let store = TestStore(initialState: LifeCalendarReducer.State()) {
            LifeCalendarReducer()
        } withDependencies: {
            $0.userSettingsClient.birthdayPublisher = birthdayPublisher.eraseToAnyPublisher()
            $0.userSettingsClient.lifeExpectancyPublisher = lifeExpectancyPublisher.eraseToAnyPublisher()
            $0.mainQueue = mainQueue.eraseToAnyScheduler()
        }
        
        // Start a birthday and life expectancy listeners
        let task = await store.send(.onAppear)
  
        let firstLifeExpectancy = 100
        let firstBirthday = Date.createDate(year: 2000, month: 1, day: 1)
        let firstLife = Life(birthday: firstBirthday, lifeExpectancy: firstLifeExpectancy)
        lifeExpectancyPublisher.send(firstLifeExpectancy)
        birthdayPublisher.send(firstBirthday)
        await mainQueue.advance(by: .seconds(1))
        await store.receive(.lifeChanged(firstLife)) {
            $0.life = firstLife
        }
        
        let secondLifeExpectancy = 70
        let secondBirthday = Date.createDate(year: 1990, month: 1, day: 2)
        let secondLife = Life(birthday: secondBirthday, lifeExpectancy: secondLifeExpectancy)
        lifeExpectancyPublisher.send(secondLifeExpectancy)
        birthdayPublisher.send(secondBirthday)
        await mainQueue.advance(by: .seconds(1))
        await store.receive(.lifeChanged(secondLife)) {
            $0.life = secondLife
        }
        // Cancel the listener
        await task.cancel()
        
        // Verify that new values are not received after cancellation
        let thirdLifeExpectancy = 70
        let thirdBirthday = Date.createDate(year: 1980, month: 3, day: 3)
        lifeExpectancyPublisher.send(thirdLifeExpectancy)
        birthdayPublisher.send(thirdBirthday)
        await mainQueue.advance(by: .seconds(1))
        XCTAssert(store.state.life == secondLife)
    }
    
    func testCalendarTypeChanged_ShouldUpdateCalendarType() async {
        let store = TestStore(initialState: LifeCalendarReducer.State()) {
            LifeCalendarReducer()
        }
        
        await store.send(.calendarTypeChanged(.currentYear)) {
            $0.calendarType = .currentYear
        }
        
        await store.send(.calendarTypeChanged(.life)) {
            $0.calendarType = .life
        }
    }
    
    func testCalendarTypeChanged_ShouldAddToAnalytics() async {
        var eventName = ""
        var eventPayload = [String: String]()
        let store = TestStore(initialState: LifeCalendarReducer.State()) {
            LifeCalendarReducer()
        } withDependencies: {
            $0.analyticsClient.sendWithPayload = { event, payload in
                eventName = event
                eventPayload = payload
            }
        }
        store.exhaustivity = .off
        
        await store.send(.calendarTypeChanged(.currentYear))
        
        XCTAssertEqual(eventName, "life_calendar.calendar_type_changed")
        XCTAssertEqual(eventPayload, ["calendarType": "\(LifeCalendarReducer.State.CalendarType.currentYear)"])
    }
    
    func testLifeChanged_ShouldUpdateLife() async {
        let life = Life(
            birthday: Date.createDate(year: 2000, month: 1, day: 1),
            lifeExpectancy: 100
        )
        let store = TestStore(initialState: LifeCalendarReducer.State()) {
            LifeCalendarReducer()
        }
        
        await store.send(.lifeChanged(life)) {
            $0.life = life
        }
    }
    
    func testAboutLifeCalendarButtonTapped_ShouldShowAboutTheCalendarSheet() async {
        let life = Life.mock
        let store = TestStore(initialState: LifeCalendarReducer.State(life: life)) {
            LifeCalendarReducer()
        }
        
        await store.send(.aboutLifeCalendarButtonTapped) {
            $0.aboutTheApp = .init(life: life)
        }
    }
    
    func testAboutLifeCalendarButtonTapped_ShouldAddToAnalytics() async {
        var eventName = ""
        let store = TestStore(initialState: LifeCalendarReducer.State()) {
            LifeCalendarReducer()
        } withDependencies: {
            $0.analyticsClient.send = { event in
                eventName = event
            }
        }
        store.exhaustivity = .off
        
        await store.send(.aboutLifeCalendarButtonTapped)
        
        XCTAssertEqual(eventName, "life_calendar.about_life_calendar_button_tapped")
    }
}

