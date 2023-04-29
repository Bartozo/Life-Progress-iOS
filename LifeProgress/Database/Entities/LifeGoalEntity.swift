//
//  LifeGoalEntity.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 29/04/2023.
//

import CoreData

extension LifeGoalEntity {
    
    /// The count of days in which the habit was marked as completed
    var isCompleted: Bool {
        return finishedAt != nil
    }

}
