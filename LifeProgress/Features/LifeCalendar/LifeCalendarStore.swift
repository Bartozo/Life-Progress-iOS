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

/// A reducer that manages the state of the life calendar.
@Reducer
struct LifeCalendarReducer {
    
    /// The state of the life calendar.
    @ObservableState
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
        
        /// The about the app state.
        @Presents var aboutTheApp: AboutTheAppReducer.State?
        
        /// The in-app purchases's state.
        var iap = IAPReducer.State()
        
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
    }
    
    /// The actions that can be taken on the life calendar.
    enum Action: BindableAction, Equatable {
        /// The binding for the life calendar.
        case binding(BindingAction<State>)
        /// Indicates that the view has appeared.
        case onAppear
        /// Indicates that the calendar type has changed.
        case calendarTypeChanged(LifeCalendarReducer.State.CalendarType)
        /// Indicates that the life has changed.
        case lifeChanged(Life)
        /// Indicates that is about the life calendar button has been tapped.
        case aboutLifeCalendarButtonTapped
        /// The actions that can be taken on the about the app.
        case aboutTheApp(PresentationAction<AboutTheAppReducer.Action>)
        /// The actions that can be taken on the in-app purchase.
        case iap(IAPReducer.Action)
    }
    
    @Dependency(\.userSettingsClient) var userSettingsClient
    
    @Dependency(\.analyticsClient) var analyticsClient
    
    /// The body of the reducer that processes incoming actions and updates the state accordingly.
    var body: some Reducer<State, Action> {
        BindingReducer()
        Scope(state: \.iap, action: \.iap) {
            IAPReducer()
        }
        Reduce { state, action in
            switch action {
            case .binding(\.calendarType):
                analyticsClient.sendWithPayload(
                    "life_calendar.calendar_type_changed", [
                        "calendarType": "\(state.calendarType)"
                    ])
                return .none
                
            case .binding:
                return .none
                
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
                state.aboutTheApp = .init(life: state.life)
                return .none
                
            case .aboutTheApp:
                return .none
                
            case .iap:
                return .none
            }
        }
        .ifLet(\.$aboutTheApp, action: \.aboutTheApp) {
            AboutTheAppReducer()
        }
    }
}

