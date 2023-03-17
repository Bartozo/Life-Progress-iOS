//
//  Theme.swift
//  LifeProgress
//
//  Created by Bartosz Król on 17/03/2023.
//

import Foundation
import SwiftUI

public struct Theme: Equatable {
    enum Key: EnvironmentKey {
        static var defaultValue: Theme { Theme(color: Color.blue) }
    }
    
    init(color: Color) {
        self.color = color
        self.text = color.description
        self.token = UUID()
    }

    var color = Color.blue
    var text = "xd"
    let token: UUID
    
    public static func == (a: Self, b: Self) -> Bool { a.token == b.token }
}

extension EnvironmentValues {
    
   public var theme: Theme {
       get { self[Theme.Key.self] }
       set { self[Theme.Key.self] = newValue }
   }
}
