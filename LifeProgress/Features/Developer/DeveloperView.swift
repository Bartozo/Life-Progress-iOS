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
    
    let store: StoreOf<DeveloperReducer>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Button {
                viewStore.send(.developerButtonTapped)
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
        let store = Store(initialState: DeveloperReducer.State()) {
            DeveloperReducer()
        }
        
        DeveloperView(store: store)
    }
}

