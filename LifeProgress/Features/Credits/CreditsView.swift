//
//  CreditsView.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 01/08/2023.
//

import SwiftUI
import ComposableArchitecture

struct CreditsView: View {
    
    @Environment(\.theme) var theme
    
    let store: StoreOf<CreditsReducer>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            List {
                Section {
                    ForEach(viewStore.packageCredits, id: \.id) { packageCredit in
                        CreditCell(
                            title: packageCredit.title,
                            onTapped: {
                                viewStore.send(.packageCreditTapped(packageCredit))
                            }
                        )
                    }
                } header: {
                    Text("Dependencies")
                }
            }
            .navigationTitle("Credits")
        }
    }
}

// MARK: - Previews

#Preview {
    let store = Store(initialState: CreditsReducer.State()) {
        CreditsReducer()
    }
    
    return NavigationStack {
        CreditsView(store: store)
    }
}
