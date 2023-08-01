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
    
    let store: CreditsStore
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
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

struct CreditsView_Previews: PreviewProvider {
    
    static var previews: some View {
        let store = Store<CreditsReducer.State, CreditsReducer.Action>(
            initialState: CreditsReducer.State(),
            reducer: CreditsReducer()
        )
        
        NavigationStack {
            CreditsView(store: store)
        }
    }
}

