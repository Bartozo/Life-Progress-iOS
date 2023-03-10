//
//  Life.swift
//  LifeProgress
//
//  Created by Bartosz Król on 08/03/2023.
//

import Foundation

/**
 A struct representing a person's life, including their age, current week of the year, and life expectancy.
 */
struct Life: Equatable {
    
    // MARK: - Static variables
    
    /// The total number of weeks in a year.
    static let totalWeeksInAYear = 52

    // MARK: - Variables
    
    /// The person's age in years.
    let age: Int
    
    /// The person's current week of the year.
    let weekOfYear: Int
    
    /// The person's life expectancy in years.
    let lifeExpectancy: Int
    
    // MARK: - Constructor
    
    /**
      Initializes a new instance of the `Life` struct.
      
      - Parameter birthday: The person's date of birth.
      - Parameter lifeExpectancy: The person's life expectancy in years.
      */
    init(birthday: Date, lifeExpectancy: Int) {
        let ageComponents = Calendar.current.dateComponents(
            [.year, .weekOfYear],
            from: birthday,
            to: .now)
        
        self.age = ageComponents.year!
        self.weekOfYear = ageComponents.weekOfYear!
        self.lifeExpectancy = lifeExpectancy
    }
    
    // MARK: - Computed properties
    
    /// The person's progress through their life as a percentage.
    var progress: Double {
        let realAge = Double(age) + Double(weekOfYear) /
            Double(Life.totalWeeksInAYear)
        let progress = realAge / Double(lifeExpectancy)
        
        return progress
    }
    
    /// The person's progress through their life formatted as a string.
    var formattedProgress: String {
        String(format: "%.1f", progress * 100)
    }
    
    /// The person's progress through the current year as a percentage.
    var currentYearProgress: Double {
        Double(weekOfYear) / Double(Life.totalWeeksInAYear)
    }
    
    /// The person's progress through the current year formatted as a string.
    var formattedCurrentYearProgress: String {
        String(format: "%.1f", currentYearProgress * 100)
    }
    
    /// The number of weeks remaining in the current year.
    var currentYearRemainingWeeks: Int {
        Life.totalWeeksInAYear - weekOfYear
    }
    
    /// The number of weeks spent in the current year.
    var currentYearSpentWeeks: Int {
        Life.totalWeeksInAYear - currentYearRemainingWeeks
    }
    
    /// The total number of weeks the person has spent alive.
    var numberOfWeeksSpent: Int {
        Life.totalWeeksInAYear * age + weekOfYear
    }
    
    /// The total number of weeks the person has left in his life.
    var numberOfWeeksLeft: Int {
        Life.totalWeeksInAYear * lifeExpectancy - numberOfWeeksSpent
    }
}
