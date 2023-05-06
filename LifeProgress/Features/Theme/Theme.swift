//
//  Theme.swift
//  LifeProgress
//
//  Created by Bartosz Król on 17/03/2023.
//

import Foundation
import SwiftUI

enum Theme: String, CaseIterable {
    case red
    case orange
    case yellow
    case green
    case mint
    case cyan
    case blue
    case indigo
    case purple
    case pink
    case brown
    
    // MARK: - Computed properties
    
    /// Primary color of the theme.
    var color: Color {
        switch self {
        case .red:
            return Color.red
        case .orange:
            return Color.orange
        case .yellow:
            return Color.yellow
        case .green:
            return Color.green
        case .mint:
            return Color.mint
        case .cyan:
            return Color.cyan
        case .blue:
            return Color.blue
        case .indigo:
            return Color.indigo
        case .purple:
            return Color.purple
        case .pink:
            return Color.pink
        case .brown:
            return Color.brown
        }
    }
    
    enum Key: EnvironmentKey {
        static var defaultValue: Theme { Theme.blue }
    }
}

extension EnvironmentValues {
    
    var theme: Theme {
        get { self[Theme.Key.self] }
        set { self[Theme.Key.self] = newValue }
    }
}
