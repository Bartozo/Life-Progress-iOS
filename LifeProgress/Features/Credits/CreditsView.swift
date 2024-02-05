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
        List {
            Section {
                ForEach(store.packageCredits, id: \.id) { packageCredit in
                    CreditCell(
                        title: packageCredit.title,
                        onTapped: {
                            store.send(.packageCreditTapped(packageCredit))
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

// MARK: - Previews

#Preview {
    NavigationStack {
        CreditsView(
            store: Store(initialState: CreditsReducer.State()) {
                CreditsReducer()
            }
        )
    }
}
