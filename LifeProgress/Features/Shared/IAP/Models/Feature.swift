//
//  Feature.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 02/05/2023.
//

import Foundation

struct Feature: Hashable {
    let title: String
    let description: String
    let symbolName: String
    
    init(title: String, description: String, symbolName: String) {
        self.title = title
        self.description = description
        self.symbolName = symbolName
    }
    
    static func getFeatures() -> [Feature] {
        return [
            Feature(
                title: "Unlimited Goals",
                description: "Create as many life goals as you want.",
                symbolName: "plus.circle"
            ),
            Feature(
                title: "iCloud Sync",
                description: "Synchronize your goals across all your devices.",
                symbolName: "icloud"
            ),
            Feature(
                title: "Support Indie Dev",
                description: "Your purchase helps support the indie developer behind the app.",
                symbolName: "heart.fill"
            ),
        ]
    }
}
