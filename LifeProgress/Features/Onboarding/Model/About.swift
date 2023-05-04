//
//  About.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 04/05/2023.
//

import Foundation

/// A structure representing an aspect of the app.
struct About: Hashable {
    /// The title of the feature or aspect.
    let title: String
    
    /// A brief description explaining the aspect.
    let description: String
    
    /// The SF Symbol name associated with the aspect.
    let symbolName: String
    
    /// Initializes an `About` instance with the provided title, description, and symbol name.
    ///
    /// - Parameters:
    ///   - title: The title of the feature or aspect..
    ///   - description: A brief description explaining the aspect.
    ///   - symbolName: The SF Symbol name associated with the aspect.
    init(title: String, description: String, symbolName: String) {
        self.title = title
        self.description = description
        self.symbolName = symbolName
    }
    
    /// Retrieves a list of `About` instances representing the app's aspects.
    ///
    /// - Returns: An array of `About` instances.
    static func getAbouts() -> [About] {
        return [
            About(
                title: "Track Milestones",
                description: "Monitor your progress towards significant life events and accomplishments.",
                symbolName: "calendar.badge.clock"
            ),
            About(
                title: "Set Goals",
                description: "Define personal objectives and work towards achieving them.",
                symbolName: "flag.fill"
            ),
            About(
                title: "Stay Motivated",
                description: "Receive timely reminders and motivational messages to help you stay focused.",
                symbolName: "bell.fill"
            ),
            About(
                title: "Data Privacy",
                description: "Your data is safe with us and will not be shared with anyone.",
                symbolName: "lock.shield.fill"
            )
        ]
    }
}
