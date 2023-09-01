//
//  SimplifiedLifeCalendarView.swift
//  LifeProgress
//
//  Created by Bartosz Król on 25/03/2023.
//

import SwiftUI

struct SimplifiedLifeCalendarView: View {
    var life: Life

    var body: some View {
        GeometryReader { geometry in
            let containterHeight = geometry.size.height
            let containerWidth = geometry.size.width
            let progressWithoutCurrentYear = Double(life.age) /
                Double(life.lifeExpectancy)

            VStack(alignment: .leading, spacing: 0) {
                // Draw all age groups first, and then clip out only the top part
                // which represents the passed years
                ZStack(alignment: .topLeading) {
                    ForEach(AgeGroup.allCases, id: \.self) { group in
                        let previousAgeGroupProportion = Double(group.age) /
                            Double(life
                                .lifeExpectancy)

                        group
                            .color
                            .offset(y: containterHeight * previousAgeGroupProportion)
                    }
                }
                .frame(
                    width: containerWidth,
                    height: progressWithoutCurrentYear * containterHeight
                )
                .clipped()

                // Current year
                AgeGroup(age: life.age + 1)
                    .color
                    .frame(
                        width: life.currentYearProgress * containerWidth,
                        height: containterHeight / Double(life.lifeExpectancy)
                    )

                Spacer()
            }
            .background(Color(uiColor: .systemFill))
        }
    }
}

// MARK: - Previews

struct SimplifiedLifeCalendarView_Previews: PreviewProvider {
    
    static var previews: some View {
        SimplifiedLifeCalendarView(life: Life.mock)
    }
}
