//
//  SimplifiedYearCalendarView.swift
//  LifeProgress
//
//  Created by Bartosz Król on 09/04/2023.
//

import SwiftUI

struct SimplifiedYearCalendarView: View {
    let life: Life
    
    var body: some View {
        GeometryReader { geometry in
            let containterHeight = geometry.size.height
            let containerWidth = geometry.size.width
            let currentYearProgress = life.currentYearProgress

            VStack(alignment: .leading, spacing: 0) {
                Rectangle()
                    .fill(AgeGroup(age: life.age + 1).color)
                    .frame(
                        width: containerWidth,
                        height: currentYearProgress * containterHeight
                    )
                    .clipped()
                Spacer()
            }
            .background(Color(uiColor: .systemFill))
        }
    }
}

// MARK: - Previews

struct SimplifiedYearCalendarView_Previews: PreviewProvider {
    
    static var previews: some View {
        SimplifiedYearCalendarView(life: Life.mock)
    }
}
