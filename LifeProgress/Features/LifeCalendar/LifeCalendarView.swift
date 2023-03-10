//
//  LifeCalendarView.swift
//  LifeProgress
//
//  Created by Bartosz Król on 10/03/2023.
//

import SwiftUI
import ComposableArchitecture

struct LifeCalendarView: View {
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    
    let store: LifeCalendarStore
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            if horizontalSizeClass == .compact {
                
            } else {
                
            }
        }
    }
}

// MARK: - Previews
