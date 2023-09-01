//
//  LifeCalendarStore.swift
//  LifeProgress
//
//  Created by Bartosz Król on 09/03/2023.
//

import Foundation
import ComposableArchitecture
import WidgetKit
import Combine

/// An enumeration representing the two possible types of calendars:
///  one for the current year, and one for the entire life.
enum CalendarType: Equatable, CaseIterable {
    case life
    case currentYear
    
    var title: String {
        switch self {
        case .life:
            return "Life"
        case .currentYear:
            return "Year"
        }
    }
}

/// A reducer that manages the state of the life calendar.
struct LifeCalendarReducer: Reducer {
    
    /// The state of the life calendar.
    struct State: Equatable {
        let currentYearModeColumnCount = 6
        
        /// The current type of calendar.
        var calendarType: CalendarType = .life
        
        /// The user's life information.
        var life: Life = Life(
            birthday: Calendar.current.date(
                byAdding: .year,
                value: -28,
                to: .now
            )!,
            lifeExpectancy: 90
        )
        
        /// Whether the about calendar sheet is visible.
        var isAboutTheCalendarSheetVisible = false
        
        /// The about the app state.
        var aboutTheApp: AboutTheAppReducer.State {
            get {
                AboutTheAppReducer.State(
                    life: self.life,
                    isAboutTheCalendarSheetVisible: self.isAboutTheCalendarSheetVisible
                )
            }
            set {
                self.isAboutTheCalendarSheetVisible = newValue.isAboutTheCalendarSheetVisible
            }
        }
    }
    
    /// The actions that can be taken on the life calendar.
    enum Action: Equatable {
        /// Indicates that the view has appeared.
        case onAppear
        /// Indicates that the calendar type has changed.
        case calendarTypeChanged(CalendarType)
        /// Indicates that the life has changed.
        case lifeChanged(Life)
        /// Indicates that is about the life calendar button has been tapped.
        case aboutLifeCalendarButtonTapped
        /// Indicates that is about the app sheet should be hidden.
        case closeAboutTheCalendarSheet
        /// The actions that can be taken on the about the app.
        case aboutTheApp(AboutTheAppReducer.Action)
    }
    
    @Dependency(\.userSettingsClient) var userSettingsClient
    
    @Dependency(\.mainQueue) var mainQueue
    
    @Dependency(\.analyticsClient) var analyticsClient
    
    /// The body of the reducer that processes incoming actions and updates the state accordingly.
    var body: some Reducer<State, Action> {
        Scope(state: \.aboutTheApp, action: /Action.aboutTheApp) {
            AboutTheAppReducer()
        }
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    for await (birthday, lifeExpectancy) in Publishers.Zip(userSettingsClient.birthdayPublisher, userSettingsClient.lifeExpectancyPublisher).values {
                        let life = Life(birthday: birthday, lifeExpectancy: lifeExpectancy)
                        await send(.lifeChanged(life))
                    }
                }
                
            case .calendarTypeChanged(let calendarType):
                analyticsClient.sendWithPayload(
                    "life_calendar.calendar_type_changed", [
                        "calendarType": "\(calendarType)"
                    ])
                state.calendarType = calendarType
                return .none
                
            case .lifeChanged(let life):
                state.life = life
                return .none
                
            case .aboutLifeCalendarButtonTapped:
                analyticsClient.send("life_calendar.about_life_calendar_button_tapped")
                state.isAboutTheCalendarSheetVisible = true
                return .none
                
            case .closeAboutTheCalendarSheet:
                state.isAboutTheCalendarSheetVisible = false
                return .none
                
            case .aboutTheApp:
                return .none
            }
        }
    }
}

