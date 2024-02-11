//
//  LifeProgressView.swift
//  LifeProgress
//
//  Created by Bartosz Król on 28/03/2023.
//

import SwiftUI

struct LifeProgressView: View {
    let life: Life
    let type: LifeCalendarReducer.State.CalendarType
    
    var body: some View {
        switch type {
        case .life:
            lifeProgressInfo
        case .currentYear:
            yearProgressInfo
        }
    }
    
    var lifeProgressInfo: some View {
        return VStack(alignment: .leading) {
            Text("Life Progress: \(life.formattedProgress)%")
                .font(.title)
                .bold()
            Text(
                "**\(life.numberOfWeeksSpent)** weeks spent • **\(life.numberOfWeeksLeft)** weeks left"
            )
            .foregroundColor(.secondary)
        }
    }

    var yearProgressInfo: some View {
        return VStack(alignment: .leading) {
            Text("Year Progress: \(life.formattedCurrentYearProgress)%")
                .font(.title)
                .bold()

            Text(
                "^[**\(life.currentYearRemainingWeeks)** weeks](inflect: true) until your birthday"
            )
            .foregroundColor(.secondary)
        }
    }
}

// MARK: - Previews

#Preview {
    LifeProgressView(life: Life.mock, type: .currentYear)
}
