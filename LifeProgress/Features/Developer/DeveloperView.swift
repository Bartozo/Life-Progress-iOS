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
    
    let store: DeveloperStore
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            Button {
                viewStore.send(.onDeveloperButtonTapped)
            } label: {
                Text("Developed with ❤️ by Bartozo")
                    .font(.footnote)
            }
            .tint(theme.color)
            .overlay {
                ConfettiCannon(
                    counter: viewStore.binding(
                        get: \.confetti,
                        send: DeveloperReducer.Action.confettiChanged
                    ),
                    confettis: [
                        .text("❤️"),
                    ]
                )
            }
        }
    }
}

// MARK: - Previews

struct DeveloperView_Previews: PreviewProvider {
    
    static var previews: some View {
        let store = Store<DeveloperReducer.State, DeveloperReducer.Action>(
            initialState: DeveloperReducer.State(),
            reducer: DeveloperReducer()
        )
        DeveloperView(store: store)
    }
}

