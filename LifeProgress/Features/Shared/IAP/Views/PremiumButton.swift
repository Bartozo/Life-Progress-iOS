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
    
    struct ViewState: Equatable {
        let isSheetVisible: Bool
        let hasUnlockedPremium: Bool

        init(state: IAPReducer.State) {
            self.isSheetVisible = state.isSheetVisible
            self.hasUnlockedPremium = state.hasUnlockedPremium
        }
    }
    
    var body: some View {
        WithViewStore(self.store, observe: ViewState.init) { viewStore in
            
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
                .sheet(isPresented: viewStore.binding(
                    get: \.isSheetVisible,
                    send: IAPReducer.Action.hideSheet
                )) {
                    IAPView(store: self.store)
                }
            } else {
                EmptyView()
            }
        }
    }
}

// MARK: - Previews

struct PremiumButton_Previews: PreviewProvider {
    
    static var previews: some View {
        let store = Store(initialState: IAPReducer.State()) {
            IAPReducer()
        }

        PremiumButton(store: store)
    }
}

