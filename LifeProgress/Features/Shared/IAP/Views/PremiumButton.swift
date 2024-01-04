//
//  PremiumButton.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 06/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct PremiumButton: View {
    
    @Environment(\.theme) var theme
    
    let store: StoreOf<IAPReducer>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            
            if !viewStore.hasUnlockedPremium {
                Button(action: {
                    viewStore.send(.showSheet)
                }) {
                    Image(systemName: "crown.fill")
                }
                .tint(theme.color)
                .onAppear {
                    viewStore.send(.refreshPurchasedProducts)
                }
                .sheet(isPresented: viewStore.$isSheetVisible) {
                    IAPView(store: self.store)
                }
            } else {
                EmptyView()
            }
        }
    }
}

// MARK: - Previews

#Preview {
    let store = Store(initialState: IAPReducer.State()) {
        IAPReducer()
    }
    
    return PremiumButton(store: store)
}
