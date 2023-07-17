//
//  IAPTests.swift
//  LifeProgressTests
//
//  Created by Bartosz Król on 15/07/2023.
//

import XCTest
import ComposableArchitecture

@testable import Life_Progress___Calendar
import StoreKitTest

@MainActor
class IAPTests: XCTestCase {
    
    var session: SKTestSession!
    
    override func setUpWithError() throws {
        session = try! SKTestSession(configurationFileNamed: "Configuration")
        session.disableDialogs = true
    }

    override func tearDownWithError() throws {
        session.clearTransactions()
        session = nil
    }
    
    func testProductIds_ShouldBeCorrect() async {
        let productIds: Set<String> = ["com.bartozo.lifeprogress.premium"]
        let store = TestStore(
            initialState: IAPReducer.State(),
            reducer: IAPReducer()
        )
        
        XCTAssertEqual(store.state.productIds, productIds)
    }
    
    func testFetchProducts_ShouldShowProducts() async {
        let products = try! await Product.products(for: ["com.bartozo.lifeprogress.premium"])
        let store = TestStore(
            initialState: IAPReducer.State(),
            reducer: IAPReducer()
        ) {
            $0.iapClient.requestProducts = { @MainActor _ in
                products
            }
        }
        
        await store.send(.fetchProducts) {
            $0.isLoading = true
        }
        
        await store.receive(.productsResponse(.success(products)), timeout: Duration.seconds(1)) {
            $0.isLoading = false
            $0.products = products
        }
    }
    
    func testFetchProducts_ShouldShowError() async {
        let store = TestStore(
            initialState: IAPReducer.State(),
            reducer: IAPReducer()
        ) {
            $0.iapClient.requestProducts = { _ in
                throw PurchaseError.unknown
            }
        }
        
        await store.send(.fetchProducts) {
            $0.isLoading = true
        }
        
        await store.receive(.productsResponse(.failure(PurchaseError.unknown)), timeout: Duration.seconds(1)) {
            $0.isLoading = false
            $0.alert = AlertState {
                TextState("Product Fetch Failed")
            } actions: {
                ButtonState(role: .cancel) {
                    TextState("Ok")
                }
            } message: {
                TextState("Unable to fetch available in-app purchases. Please check your internet connection and try again.")
            }
        }
    }
    
    func testPurchase_ShouldPurchaseProduct() async {
        let products = try! await Product.products(for: ["com.bartozo.lifeprogress.premium"])
        let id = "id"
        let store = TestStore(
            initialState: IAPReducer.State(products: products),
            reducer: IAPReducer()
        ) {
            $0.iapClient.purchase  = { _ in
                id
            }
        }
        
        let product = store.state.products.first!
        await store.send(.purchase(product))
        
        await store.receive(.purchaseResponse(.success(id)), timeout: Duration.seconds(1)) {
            $0.isLoading = false
            $0.isSheetVisible = false
            $0.purchasedProductIDs = [id]
        }
    }
    
    func testPurchase_ShouldShowError() async {
        let products = try! await Product.products(for: ["com.bartozo.lifeprogress.premium"])
        let store = TestStore(
            initialState: IAPReducer.State(products: products),
            reducer: IAPReducer()
        ) {
            $0.iapClient.purchase = { _ in
                throw PurchaseError.unknown
            }
        }
        
        let product = store.state.products.first!
        await store.send(.purchase(product))
        
        await store.receive(.purchaseResponse(.failure(PurchaseError.unknown)), timeout: Duration.seconds(1)) {
            $0.isLoading = false
            $0.alert = AlertState {
                TextState("Purchase Failed")
              } actions: {
                ButtonState(role: .cancel) {
                  TextState("Ok")
                }
              } message: {
                  TextState("The in-app purchase could not be completed. Please check your internet connection and try again.")
              }
        }
    }
    
    func testPurchase_ShouldAddToAnalytics() async {
        var eventName = ""
        let products = try! await Product.products(for: ["com.bartozo.lifeprogress.premium"])
        let store = TestStore(
            initialState: IAPReducer.State(products: products),
            reducer: IAPReducer()
        ) {
            $0.iapClient.purchase = { _ in
                "id"
            }
            $0.analyticsClient.send = { event in
                eventName = event
            }
        }
        store.exhaustivity = .off
        
        let product = store.state.products.first!
        await store.send(.purchase(product))

        XCTAssertEqual(eventName, "iap.purchase_response_success")
    }
    
    func testPurchase_ShouldAddErrorToAnalytics() async {
        var eventName = ""
        let products = try! await Product.products(for: ["com.bartozo.lifeprogress.premium"])
        let store = TestStore(
            initialState: IAPReducer.State(products: products),
            reducer: IAPReducer()
        ) {
            $0.iapClient.purchase = { _ in
                throw PurchaseError.unknown
            }
            $0.analyticsClient.send = { event in
                eventName = event
            }
        }
        store.exhaustivity = .off
        
        let product = store.state.products.first!
        await store.send(.purchase(product))

        XCTAssertEqual(eventName, "iap.purchase_response_failure")
    }
    
    func testCloseButtonTapped_ShouldHideSheet() async {
        let store = TestStore(
            initialState: IAPReducer.State(isSheetVisible: true),
            reducer: IAPReducer()
        )
        
        await store.send(.closeButtonTapped) {
            $0.isSheetVisible = false
        }
    }
    
    func testShowSheet_ShouldShowSheet() async {
        let store = TestStore(
            initialState: IAPReducer.State(),
            reducer: IAPReducer()
        )
        
        await store.send(.showSheet) {
            $0.isSheetVisible = true
        }
    }
    
    func testHideSheet_ShouldHideSheet() async {
        let store = TestStore(
            initialState: IAPReducer.State(isSheetVisible: true),
            reducer: IAPReducer()
        )
        
        await store.send(.hideSheet) {
            $0.isSheetVisible = false
        }
    }
    
    func testBuyPremiumButtonTapped_ShouldBuyProduct() async {
        let products = try! await Product.products(for: ["com.bartozo.lifeprogress.premium"])
        let store = TestStore(
            initialState: IAPReducer.State(products: products),
            reducer: IAPReducer()
        ) {
            $0.iapClient.purchase = { _ in
                throw PurchaseError.unknown
            }
        }
        
        await store.send(.buyPremiumButtonTapped) {
            $0.isLoading = true
        }
        
        let product = store.state.products.first!
        await store.receive(.purchase(product), timeout: Duration.seconds(1))
        
        await store.receive(.purchaseResponse(.failure(PurchaseError.unknown))) {
            $0.isLoading = false
            $0.alert = AlertState {
                TextState("Purchase Failed")
              } actions: {
                ButtonState(role: .cancel) {
                  TextState("Ok")
                }
              } message: {
                  TextState("The in-app purchase could not be completed. Please check your internet connection and try again.")
              }
        }
    }
    
    func testBuyPremiumButtonTapped_ShouldAddToAnalytics() async {
        var eventName = ""
        let products = try! await Product.products(for: ["com.bartozo.lifeprogress.premium"])
        let store = TestStore(
            initialState: IAPReducer.State(products: products),
            reducer: IAPReducer()
        ) {
            $0.iapClient.purchase = { _ in
                throw PurchaseError.unknown
            }
            $0.analyticsClient.send = { event in
                if eventName.isEmpty {
                    eventName = event
                }
            }
        }
        store.exhaustivity = .off
        
        await store.send(.buyPremiumButtonTapped)
        
        XCTAssertEqual(eventName, "iap.buy_premium_button_tapped")
    }
    
    func testRestorePurchasesButtonTapped_ShouldRestorePurchases() async {
        let store = TestStore(
            initialState: IAPReducer.State(isSheetVisible: true),
            reducer: IAPReducer()
        ) {
            $0.iapClient.restorePurchases = {
                true
            }
        }

        await store.send(.restorePurchasesButtonTapped)
        
        await store.receive(.restorePurchasesResponse(.success(true))) {
            $0.isLoading = false
            $0.isSheetVisible = false
        }
    }
    
    func testRestorePurchasesButtonTapped_ShouldntRestorePurchases() async {
        var eventName = ""
        let store = TestStore(
            initialState: IAPReducer.State(),
            reducer: IAPReducer()
        ) {
            $0.iapClient.restorePurchases = {
                throw PurchaseError.unknown
            }
        }
    
        await store.send(.restorePurchasesButtonTapped)
        
        await store.receive(.restorePurchasesResponse(.failure(PurchaseError.unknown)), timeout: Duration.seconds(1))
    }
    
    
    func testRestorePurchasesButtonTapped_ShouldAddToAnalytics() async {
        var eventNames: [String] = []
        let store = TestStore(
            initialState: IAPReducer.State(),
            reducer: IAPReducer()
        ) {
            $0.iapClient.purchase = { _ in
                throw PurchaseError.unknown
            }
            $0.analyticsClient.send = { event in
                eventNames.append(event)
            }
        }
        store.exhaustivity = .off
        
        await store.send(.restorePurchasesButtonTapped)
        
        XCTAssertEqual(eventNames[0], "iap.restore_purchases_button_tapped")
        XCTAssertEqual(eventNames[1], "iap.restore_purchases_response_success")
    }
    
    func testRestorePurchasesButtonTapped_ShouldAddErrorToAnalytics() async {
        var eventNames: [String] = []
        let store = TestStore(
            initialState: IAPReducer.State(),
            reducer: IAPReducer()
        ) {
            $0.iapClient.restorePurchases = {
                throw PurchaseError.unknown
            }
            $0.analyticsClient.send = { event in
                eventNames.append(event)
            }
        }
        store.exhaustivity = .off
        
        await store.send(.restorePurchasesButtonTapped)
        
        XCTAssertEqual(eventNames[1], "iap.restore_purchases_response_failure")
    }
    
    func testRefreshPurchasedProducts_ShouldShowPurchasedProducts() async {
        let ids = ["1", "2", "3"]
        let store = TestStore(
            initialState: IAPReducer.State(),
            reducer: IAPReducer()
        ) {
            $0.iapClient.requestPurchasedProductIds = {
                ids
            }
        }
        
        await store.send(.refreshPurchasedProducts)
        
        await store.receive(.refreshPurchasedProductsResponse(ids)) {
            $0.purchasedProductIDs = Set(ids)
        }
    }
    
    func testAlertDismissed_ShouldDismissAlert() async {
        let store = TestStore(
            initialState: IAPReducer.State(
                alert: AlertState {
                    TextState("Product Fetch Failed")
                } actions: {
                    ButtonState(role: .cancel) {
                        TextState("Ok")
                    }
                } message: {
                    TextState("Unable to fetch available in-app purchases. Please check your internet connection and try again.")
                }
            ),
            reducer: IAPReducer()
        )
        
        await store.send(.alertDismissed) {
            $0.alert = nil
        }
    }
}
