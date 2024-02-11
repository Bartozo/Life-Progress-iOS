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
    
    @Bindable var store: StoreOf<IAPReducer>
    
    var body: some View {
        NavigationStack {
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
                VStack(spacing: 8) {
                    PriceLabel(store: self.store)
                    
                    VStack(spacing: 20) {
                        BuyPremiumButton(store: self.store)
                        
                        Button {
                            store.send(.restorePurchasesButtonTapped)
                        } label: {
                            Text("Restore Purchases")
                                .font(.subheadline)
                        }
                        .tint(theme.color)
                    }
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        store.send(.closeButtonTapped)
                    } label: {
                        Text("Close")
                    }
                    .tint(theme.color)
                }
            }
            .onAppear {
                store.send(.fetchProducts)
            }
            .alert($store.scope(state: \.alert, action: \.alert))
        }
    }
}

private struct PriceLabel: View {
    
    let store: StoreOf<IAPReducer>
    
    var body: some View {
        VStack(alignment: .center) {
            if let product = store.products.first {
                Text("\(product.displayPrice)")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.secondary)
            }
            Text("Buy once. Enjoy forever!")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

private struct BuyPremiumButton: View {
    
    @Environment(\.theme) var theme
    
    let store: StoreOf<IAPReducer>
    
    var body: some View {
        Button {
            if (!store.isLoading) {
                store.send(.buyPremiumButtonTapped)
            }
        } label: {
            HStack {
                Text("Unlock Premium")
                    .font(.callout.weight(.semibold))
                    .padding(8)
                
                if (store.isLoading) {
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

// MARK: - Previews

#Preview {
    IAPView(
        store: Store(initialState: IAPReducer.State()) {
            IAPReducer()
        }
    )
}
