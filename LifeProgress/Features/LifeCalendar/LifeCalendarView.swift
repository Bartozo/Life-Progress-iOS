//
//  LifeCalendarView.swift
//  LifeProgress
//
//  Created by Bartosz Król on 10/03/2023.
//

import SwiftUI
import ComposableArchitecture

struct LifeCalendarView: View {
    
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    
    let store: LifeCalendarStore

    
    var body: some View {
        if verticalSizeClass == .regular {
            calendar
        } else {
            ScrollView(showsIndicators: false) {
                calendar
            }
        }
    }
    
    private var calendar: some View {
        WithViewStore(self.store) { viewStore in
            let life = viewStore.life
            let calendarType = viewStore.calendarType
            let currentYearModeColumnCount = viewStore.currentYearModeColumnCount

            let fullCalendarAspectRatio = Double(Life.totalWeeksInAYear) / Double(life.lifeExpectancy)
            let currentYearGridAspectRatio = Double(currentYearModeColumnCount) / (Double(Life.totalWeeksInAYear) / Double(currentYearModeColumnCount) + 1)

            ZStack(alignment: .topLeading) {
                CalendarWithoutCurrentYear(store: self.store)
                CalendarWithCurrentYear(store: self.store)
            }
            .aspectRatio(
                min(fullCalendarAspectRatio, currentYearGridAspectRatio),
                contentMode: .fit
            )
            .onTapGesture {
                viewStore.send(.calendarTypeChanged(
                    calendarType == .currentYear ? .life : .currentYear)
                )
            }
        }
        .navigationTitle("Life Calendar")
    }
}

// MARK: - Previews
