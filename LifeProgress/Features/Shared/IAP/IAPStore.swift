//
//  IAPStore.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 02/05/2023.
//

import Foundation
import ComposableArchitecture
import StoreKit

/// A type alias for a store of the `IAPReducer`'s state and action types.
typealias IAPStore = Store<IAPReducer.State, IAPReducer.Action>

/// A reducer that manages the state of the IAP.
struct IAPReducer: ReducerProtocol {
    
    /// The state of the IAP.
    struct State: Equatable {
        /// The list of product identifiers for in-app purchase.
        let productIds: Set<String> = ["com.bartozo.lifeprogress.premium"]
        
        /// The list of available products for in-app purchase.
        var products: [Product] = []
        
        /// The set of purchased product identifiers.
        var purchasedProductIDs = Set<String>()
        
        /// Indicates whether the products are being loaded.
        var isLoading = false
        
        /// Indicates whether the user has unlocked the premium.
        var hasUnlockedPremium: Bool {
            return purchasedProductIDs.contains("com.bartozo.lifeprogress.premium")
        }
        
        /// Whether the about IAP sheet is visible.
        var isSheetVisible = false
        
        /// The state of the alert related to IAP actions.
        var alert: AlertState<Action>?
    }
    
    /// The actions that can be taken on the IAP.
    enum Action: Equatable {
        /// Indicates that products should be fetched.
        case fetchProducts
        /// The result of the fetch products request.
        case productsResponse(TaskResult<[Product]>)
        /// Indicates that the specified product should be purchased.
        case purchase(Product)
        /// The result of the purchase request.
        case purchaseResponse(TaskResult<String>)
        /// Indicates that the close button has been tapped.
        case closeButtonTapped
        /// Indicates that the sheet should be visible.
        case showSheet
        /// Indicates that the sheet should be hidden.
        case hideSheet
        /// Indicates that the buy premium button has been tapped.
        case buyPremiumButtonTapped
        /// Indicates that the buy restore purchases button has been tapped.
        case restorePurchasesButtonTapped
        /// The result of the restore purchases request.
        case restorePurchasesResponse(TaskResult<Bool>)
        /// Indicates that purchased products should be fetched again.
        case refreshPurchasedProducts
        /// The result of the refresh purchased products request.
        case refreshPurchasedProductsResponse([String])
        /// Indicates that the alert has been dismissed.
        case alertDismissed
    }
    
    @Dependency(\.iapClient) var iapClient
    
    @Dependency(\.analyticsClient) var analyticsClient
    
    private enum CancelID {}
    
    /// The body of the reducer that processes incoming actions and updates the state accordingly.
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetchProducts:
                analyticsClient.send("iap.fetch_products")
                state.isLoading = true
                return .task { [productIds = state.productIds] in
                    await .productsResponse(TaskResult {
                        try await self.iapClient.requestProducts(productIds)
                    })
                }
                .cancellable(id: CancelID.self)

            case .productsResponse(.success(let products)):
                analyticsClient.send("iap.products_response_success")
                state.isLoading = false
                state.products = products
                return .none

            case .productsResponse(.failure):
                analyticsClient.send("iap.products_response_failure")
                state.isLoading = false
                state.alert = AlertState {
                    TextState("Product Fetch Failed")
                } actions: {
                    ButtonState(role: .cancel) {
                        TextState("Ok")
                    }
                } message: {
                    TextState("Unable to fetch available in-app purchases. Please check your internet connection and try again.")
                }
                return .none
                
            case .purchase(let product):
                return .task {
                    await .purchaseResponse(TaskResult {
                        try await self.iapClient.purchase(product)
                    })
                }
                .cancellable(id: CancelID.self)
                
            case .purchaseResponse(.success(let productId)):
                analyticsClient.send("iap.purchase_response_success")
                state.purchasedProductIDs.insert(productId)
                state.isLoading = false
                state.isSheetVisible = false
                return .none
    
            case .purchaseResponse(.failure):
                analyticsClient.send("iap.purchase_response_failure")
                state.isLoading = false
                state.alert = AlertState {
                  TextState("Purchase Failed")
                } actions: {
                  ButtonState(role: .cancel) {
                    TextState("Ok")
                  }
                } message: {
                  TextState("The in-app purchase could not be completed. Please check your internet connection and try again.")
                }
                return .none
                
            case .showSheet:
                state.isSheetVisible = true
                return .none
                
            case .hideSheet:
                state.isSheetVisible = false
                return .none
                
            case .closeButtonTapped:
                state.isSheetVisible = false
                return .none
                
            case .buyPremiumButtonTapped:
                analyticsClient.send("iap.buy_premium_button_tapped")
                guard let product = state.products.first else {
                    return .none
                }
                
                state.isLoading = true
                return .send(.purchase(product))
                
            case .restorePurchasesButtonTapped:
                analyticsClient.send("iap.restore_purchases_button_tapped")
                return .task {
                    await .restorePurchasesResponse(TaskResult {
                        try await self.iapClient.restorePurchases()
                    })
                }
                .cancellable(id: CancelID.self)
                
            case .restorePurchasesResponse(.success):
                analyticsClient.send("iap.restore_purchases_response_success")
                state.isLoading = false
                state.isSheetVisible = false
                return .none
    
            case .restorePurchasesResponse(.failure):
                analyticsClient.send("iap.restore_purchases_response_failure")
                return .none
                
            case .refreshPurchasedProducts:
                return .task {
                    let purchasedProductsIds = await self.iapClient.requestPurchasedProductIds()
                    return .refreshPurchasedProductsResponse(purchasedProductsIds)
                }
                .cancellable(id: CancelID.self)

            case .refreshPurchasedProductsResponse(let purchasedProductsIds):
                state.purchasedProductIDs = Set(purchasedProductsIds)
                return .none
                
            case .alertDismissed:
                state.alert = nil
                return .none
            }
        }
    }
}
