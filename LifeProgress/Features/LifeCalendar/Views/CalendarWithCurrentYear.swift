//
//  CalendarWithCurrentYear.swift
//  LifeProgress
//
//  Created by Bartosz Król on 10/03/2023.
//

import SwiftUI
import ComposableArchitecture

struct CalendarWithCurrentYear: View {
    let store: StoreOf<LifeCalendarReducer>
    
    var body: some View {
        let life = store.life
        let calendarType = store.calendarType
        let currentYearModeColumnCount = store.currentYearModeColumnCount
        
        GeometryReader { geometry in
            let totalWeeksInAYear = Life.totalWeeksInAYear
            let containerWidth = geometry.size.width
            let cellSize: Double = {
                switch calendarType {
                case .currentYear:
                    return containerWidth / Double(currentYearModeColumnCount)
                case .life:
                    return containerWidth / Double(Life.totalWeeksInAYear)
                }
            }()
            let cellPadding = cellSize / 12
            
            ForEach(0..<totalWeeksInAYear, id: \.self) { weekIndex in
                let rowIndex: Int = {
                    switch calendarType {
                    case .currentYear:
                        return weekIndex / currentYearModeColumnCount
                    case .life:
                        return life.age - 1
                    }
                }()
                let columnIndex: Int = {
                    switch (calendarType) {
                    case .currentYear:
                        return weekIndex % currentYearModeColumnCount
                    case .life:
                        return weekIndex
                    }
                }()
                let color = (weekIndex < life.weekOfYear)
                    ? AgeGroup(age: life.age + 1).color
                    : Color(.systemFill)
                
                Rectangle()
                    .fill(color)
                    .padding(cellPadding)
                    .frame(width: cellSize, height: cellSize)
                    .offset(
                        x: Double(columnIndex) * cellSize,
                        y: Double(rowIndex) * cellSize
                    )
                    .animation(
                        calendarAnimation(for: calendarType),
                        value: calendarType
                    )
            }
        }
        .aspectRatio(contentMode: .fit)
    }
    
    /**
       Calculates the appropriate animation to use when changing the calendar type.
       
       - Parameter calendarType: A `CalendarType` object representing the current calendar type.

       - Returns: An `Animation` object representing the appropriate animation to use.
     */
    private func calendarAnimation(for calendarType: LifeCalendarReducer.State.CalendarType) -> Animation {
        let animation = Animation.easeInOut(duration: 0.4)
        guard calendarType == .life else {
            return animation.delay(0.4)
        }
        
        return animation
    }
}
