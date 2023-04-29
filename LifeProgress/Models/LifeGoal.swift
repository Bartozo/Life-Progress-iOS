//
//  LifeGoal.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 29/04/2023.
//

import Foundation

struct LifeGoal: Identifiable, Equatable {
    let id: UUID
    let title: String
    let finishedAt: Date?
    let symbolName: String
    let details: String
    
    init(id: UUID, title: String, finishedAt: Date?, symbolName: String, details: String) {
        self.id = id
        self.title = title
        self.finishedAt = finishedAt
        self.symbolName = symbolName
        self.details = details
    }
    
    /// Whether the life goal was completed.
    var isCompleted: Bool {
        return finishedAt != nil
    }
}
