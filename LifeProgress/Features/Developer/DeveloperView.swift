//
//  DeveloperView.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 04/05/2023.
//

import SwiftUI
import ComposableArchitecture
import ConfettiSwiftUI

struct DeveloperView: View {
    
    @Environment(\.theme) var theme
    
    @Bindable var store: StoreOf<DeveloperReducer>
    
    var body: some View {
        Button {
            store.send(.developerButtonTapped)
        } label: {
            Text("Developed with ❤️ by Bartozo")
                .font(.footnote)
        }
        .tint(theme.color)
        .overlay {
            ConfettiCannon(
                counter: $store.confetti,
                confettis: [
                    .text("❤️"),
                ]
            )
        }
    }
}

// MARK: - Previews

#Preview {
    DeveloperView(
        store: Store(initialState: DeveloperReducer.State()) {
            DeveloperReducer()
        }
    )
}
