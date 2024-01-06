//
//  ConfettiView.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 01/05/2023.
//

import SwiftUI
import ComposableArchitecture
import ConfettiSwiftUI

struct ConfettiView: View {
    let store: StoreOf<ConfettiReducer>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ConfettiCannon(
                counter: viewStore.$confetti,
                num: 100,
                radius: 350
            )
        }
    }
}

// MARK: - Previews

#Preview {
    let store = Store(initialState: ConfettiReducer.State()) {
        ConfettiReducer()
    }
    
    return ConfettiView(store: store)
}
