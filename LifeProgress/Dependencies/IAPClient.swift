//
//  IAPClient.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 02/05/2023.
//

import Foundation
import StoreKit
import ComposableArchitecture

/// An enum representing the errors that may occur during a product purchase process.
enum PurchaseError: Error {
    /// Indicates that the purchase was unverified.
    case unverified
    /// Indicates that the user cancelled the purchase.
    case userCancelled
    /// Indicates that the purchase is in a pending state.
    case pending
    /// Indicates that the purchase encountered an unknown error.
    case unknown
}

/// The `IAPClient` is a struct that provides a set of closures for managing in-app purchases.
struct IAPClient {
    // A closure that asynchronously returns purchasable products.
    var requestProducts: (_ productIdentifiers: Set<String>) async throws -> [Product]
    
    // A closure that asynchronously purchases the product and return it's id.
    var purchase: (_ product: Product) async throws -> String
    
    // A closure that asynchronously returns the id's of purchased products.
    var requestPurchasedProductIds: () async -> [String]
    
    // A closure that asynchronously restoring the purchases.
    var restorePurchases: () async throws -> Bool
}


// MARK: Dependency Key

extension IAPClient: DependencyKey {
    
    /// A live value of `IAPClient` that uses the StoreKit for managing in-app purchases.
    static let liveValue = IAPClient(
        requestProducts: { productIds in
            try await Product.products(for: productIds)
        },
        purchase: { product in
            let result = try await product.purchase()
            
            switch result {
            case let .success(.verified(transaction)):
                await transaction.finish()
                return transaction.productID
                
            case .success(.unverified(_, _)):
                throw PurchaseError.unverified
                
            case .userCancelled:
                throw PurchaseError.userCancelled
                
            case .pending:
                throw PurchaseError.pending
                
            @unknown default:
                throw PurchaseError.unknown
            }
        },
        requestPurchasedProductIds: {
            var purchasedProductIDs: [String] = []
            
            for await result in Transaction.currentEntitlements {
                guard case .verified(let transaction) = result else {
                    continue
                }
                
                if transaction.revocationDate == nil {
                    purchasedProductIDs.append(transaction.productID)
                }
            }
            
            return purchasedProductIDs
        },
        restorePurchases: {
            try? await AppStore.sync()
            return true
        }
    )
}

// MARK: Dependency Values

extension DependencyValues {
    
    /// A property wrapper for accessing and updating the `IAPClient` instance within the dependency container.
    var iapClient: IAPClient {
        get { self[IAPClient.self] }
        set { self[IAPClient.self] = newValue }
    }
}

