//
//  Date+Extensions.swift
//  LifeProgressTests
//
//  Created by Bartosz Król on 18/06/2023.
//

import Foundation

extension Date {
    
    /// Creates a new Date object with a specific year, month, and day.
    ///
    /// - Returns: A `Date` object representing the specified year, month, and day.
    static func createDate(year: Int, month: Int, day: Int) -> Date {
        let calendar = Calendar.current

        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day

        return calendar.date(from: dateComponents)!
    }
}
