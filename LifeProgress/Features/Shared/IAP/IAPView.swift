//
//  IAPView.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 02/05/2023.
//

import SwiftUI
import ComposableArchitecture
import StoreKit

struct IAPView: View {
    
    @Environment(\.theme) var theme
    
    let store: IAPStore
    
    var body: some View {
        NavigationStack {
            WithViewStore(self.store) { viewStore in
                VStack {
                    List {
                        HStack {
                            Spacer()
                            Text("Life Progress Premium")
                                .font(.largeTitle.weight(.bold))
                                .multilineTextAlignment(.center)
                            Spacer()
                        }
                        .listRowBackground(Color.clear)
                        
                        Section {
                            ForEach(Feature.getFeatures(), id: \.self) { feature in
                                HStack {
                                    Image(systemName: feature.symbolName)
                                        .foregroundColor(theme.color)
                                        .font(.title.weight(.regular))
                                        .frame(width: 60, height: 50)
                                        .clipped()
                                    
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text(feature.title)
                                            .font(.footnote.weight(.semibold))
                                        Text(feature.description)
                                            .font(.footnote)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                    }
                    
                    VStack(spacing: 20) {
                        BuyPremiumButton(store: self.store)
                        
                        Button {
                            viewStore.send(.restorePurchasesButtonTapped)
                        } label: {
                            Text("Restore Purchases")
                                .font(.subheadline)
                        }
                        .tint(theme.color)
                    }
                    .padding()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            viewStore.send(.closeButtonTapped)
                        } label: {
                            Text("Close")
                        }
                        .tint(theme.color)
                    }
                }
                .onAppear {
                    viewStore.send(.fetchProducts)
                }
            }
            .alert(
              self.store.scope(state: \.alert),
              dismiss: .alertDismissed
            )
        }
    }
}

private struct BuyPremiumButton: View {
    
    @Environment(\.theme) var theme
    
    let store: IAPStore
    
    struct ViewState: Equatable {
        let isLoading: Bool
        let products: [Product]

        init(state: IAPReducer.State) {
            self.isLoading = state.isLoading
            self.products = state.products
        }
    }
    
    var body: some View {
        WithViewStore(self.store, observe: ViewState.init) { viewStore in
            Button {
                if (!viewStore.state.isLoading) {
                    viewStore.send(.buyPremiumButtonTapped)
                }
            } label: {
                HStack {
                    if let product = viewStore.state.products.first {
                        Text("\(product.displayPrice) Premium")
                            .font(.callout.weight(.semibold))
                            .padding(8)
                    }
                    
                    if (viewStore.state.isLoading) {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .tint(.white)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .tint(theme.color)
            .buttonStyle(.borderedProminent)
        }
    }
}

// MARK: - Previews

struct IAPView_Previews: PreviewProvider {
    
    static var previews: some View {
        let store = Store<IAPReducer.State, IAPReducer.Action>(
            initialState: IAPReducer.State(),
            reducer: IAPReducer()
        )
        IAPView(store: store)
    }
}
