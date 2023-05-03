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
    
    let store: IAPStore
    
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
            ZStack {
                if viewStore.hasUnlockedPremium {
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
                        viewStore.send(.showSheet)
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
                viewStore.send(.refreshPurchasedProducts)
            }
            .sheet(isPresented: viewStore.binding(
                get: \.isSheetVisible,
                send: IAPReducer.Action.hideSheet
            )) {
                IAPView(store: self.store)
            }
        }
    }
}

// MARK: - Previews

struct PremiumCell_Previews: PreviewProvider {
    
    static var previews: some View {
        let store = Store<IAPReducer.State, IAPReducer.Action>(
            initialState: IAPReducer.State(),
            reducer: IAPReducer()
        )
        PremiumCell(store: store)
    }
}
