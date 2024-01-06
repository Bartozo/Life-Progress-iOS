//
//  CurrentYearProgressView.swift
//  LifeProgress
//
//  Created by Bartosz Król on 25/03/2023.
//

import SwiftUI

struct CurrentYearProgressView: View {
    let life: Life

    var body: some View {
        GeometryReader { geometry in
            let containerWidth = geometry.size.width
            let cellSize = containerWidth / Double(Life.totalWeeksInAYear)
            let cellPadding = cellSize / 12

            HStack(alignment: .top, spacing: 0) {
                ForEach(0 ..< Life.totalWeeksInAYear, id: \.self) { weekIndex in
                    let color: Color = weekIndex < life.weekOfYear
                        ? AgeGroup(age: life.age + 1).color
                        : .secondary
                    
                    Rectangle()
                        .fill(color)
                        .padding(cellPadding)
                        .frame(width: cellSize, height: cellSize)
                }
            }
        }
        .aspectRatio(52, contentMode: .fit)
    }
}

// MARK: - Previews

#Preview {
    CurrentYearProgressView(life: Life.mock)
}
