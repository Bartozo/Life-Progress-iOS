//
//  PremiumCell.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 02/05/2023.
//

import SwiftUI
import ComposableArchitecture

struct PremiumCell: View {
    
    @Environment(\.theme) var theme
    
    @Bindable var store: StoreOf<IAPReducer>
    
    var body: some View {
        ZStack {
            if store.hasUnlockedPremium {
                HStack {
                    Image(systemName: "star.square.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .padding(.trailing, 10)
                        .tint(theme.color)

                    VStack(alignment: .leading) {
                        Text("Thank You!")
                            .font(.headline)
                            .lineLimit(2)

                        Text("You have successfully bought the premium version.")
                            .lineLimit(2)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            } else {
                Button {
                    store.send(.showSheet)
                } label: {
                    HStack {
                        Image(systemName: "star.square.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .padding(.trailing, 10)
                            .tint(theme.color)

                        VStack(alignment: .leading) {
                            Text("Get Premium")
                                .font(.headline)
                                .lineLimit(2)

                            Text("Unlimited life goals, support indie dev and more!")
                                .lineLimit(2)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .onAppear {
            store.send(.refreshPurchasedProducts)
        }
        .sheet(isPresented: $store.isSheetVisible) {
            IAPView(store: self.store)
        }
    }
}

// MARK: - Previews

#Preview {
    PremiumCell(
        store: Store(initialState: IAPReducer.State()) {
            IAPReducer()
        }
    )
}
