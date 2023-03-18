//
//  LifeCalendarStore.swift
//  LifeProgress
//
//  Created by Bartosz Król on 09/03/2023.
//

import Foundation
import ComposableArchitecture

/// An enumeration representing the two possible types of calendars:
///  one for the current year, and one for the entire life.
enum CalendarType: Equatable {
    case currentYear
    case life
}
 
/// A type alias for a store of the `LifeCalendarReducer`'s state and action types.
typealias LifeCalendarStore = Store<LifeCalendarReducer.State, LifeCalendarReducer.Action>

typealias LifeCalendarViewStore = ViewStore<LifeCalendarReducer.State, LifeCalendarReducer.Action>

/// A reducer that manages the state of the life calendar.
struct LifeCalendarReducer: ReducerProtocol {
    
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
    }
    
    /// The actions that can be taken on the life calendar.
    enum Action: Equatable {
        /// Indicates that the calendar type has changed.
        case calendarTypeChanged(CalendarType)
    }
    
    /// The body of the reducer that processes incoming actions and updates the state accordingly.
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .calendarTypeChanged(let calendarType):
                state.calendarType = calendarType
                return .none
            }
        }
    }
}

