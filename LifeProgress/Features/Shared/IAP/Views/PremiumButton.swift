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
    
    @Bindable var store: StoreOf<IAPReducer>
    
    var body: some View {
        if !store.hasUnlockedPremium {
            Button {
                store.send(.showSheet)
            } label: {
                Image(systemName: "crown.fill")
            }
            .tint(theme.color)
            .onAppear {
                store.send(.refreshPurchasedProducts)
            }
            .sheet(isPresented: $store.isSheetVisible) {
                IAPView(store: self.store)
            }
        } else {
            EmptyView()
        }
    }
}

// MARK: - Previews

#Preview {
    PremiumButton(
        store: Store(initialState: IAPReducer.State()) {
            IAPReducer()
        }
    )
}
