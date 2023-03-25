//
//  AgeGroup.swift
//  LifeProgress
//
//  Created by Bartosz Król on 09/03/2023.
//

import Foundation
import SwiftUI

/**
 * AgeGroup is an enum representing different age groups of a person.
 * It has seven cases: baby, child, adolescent, young adult, adult, middle age, and old age.
 */
enum AgeGroup: CaseIterable {
    
    // MARK: - Cases

    /// Represents the age group of a baby.
    case baby
    
    /// Represents the age group of a child.
    case child
    
    /// Represents the age group of an adolescent.
    case adolescent
    
    /// Represents the age group of a young adult.
    case youngAdult
    
    /// Represents the age group of an adult.
    case adult
    
    /// Represents the age group of a middle-aged person.
    case middleAge
    
    /// Represents the age group of an elderly person.
    case oldAge
    
    // MARK: - Initializer
    

    /**
     Initializes a new instance of the `AgeGroup` enum.
     This initializer takes an integer age as input and returns the corresponding AgeGroup case
      
     - Parameter age: The person's age.
     */
    init(age: Int) {
        switch age {
        case 0..<AgeGroup.child.age:
            self = .baby
        case AgeGroup.child.age..<AgeGroup.adolescent.age:
            self = .child
        case AgeGroup.adolescent.age..<AgeGroup.youngAdult.age:
            self = .adolescent
        case AgeGroup.youngAdult.age..<AgeGroup.adult.age:
            self = .youngAdult
        case AgeGroup.adult.age..<AgeGroup.middleAge.age:
            self = .adult
        case AgeGroup.middleAge.age..<AgeGroup.oldAge.age:
            self = .middleAge
        default:
            self = .oldAge
        }
    }
    
    // MARK: - Computed properties
    
    
    /// The age value associated with an AgeGroup.
    var age: Int {
        switch self {
        case .baby:
            return 0
        case .child:
            return 3
        case .adolescent:
            return 9
        case .youngAdult:
            return 18
        case .adult:
            return 25
        case .middleAge:
            return 40
        case .oldAge:
            return 60
        }
    }
    
    /// The color associated with an AgeGroup.
    var color: Color {
        switch self {
        case .baby:
            return .blue
        case .child:
            return .green
        case .adolescent:
            return .yellow
        case .youngAdult:
            return .orange
        case .adult:
            return .red
        case .middleAge:
            return .purple
        case .oldAge:
            return .brown
        }
    }
    
    var description: String {
        switch self {
        case .baby:
            return "Baby (0-3)"
        case .child:
            return "Child (3-9)"
        case .adolescent:
            return "Adolescent (9-18)"
        case .youngAdult:
            return "Young Adult (18-25)"
        case .adult:
            return "Adult (25-40)"
        case .middleAge:
            return "Middle Age (40-60)"
        case .oldAge:
            return "Old Age (60+)"
        }
    }
}
