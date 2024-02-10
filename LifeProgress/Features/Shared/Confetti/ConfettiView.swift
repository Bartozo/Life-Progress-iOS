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
    @Bindable var store: StoreOf<ConfettiReducer>

    var body: some View {
        ConfettiCannon(
            counter: $store.confetti,
            num: 100,
            radius: 350
        )
    }
}

// MARK: - Previews

#Preview {
    ConfettiView(
        store: Store(initialState: ConfettiReducer.State()) {
            ConfettiReducer()
        }
    )
}
