//
//  CreditsTests.swift
//  LifeProgressTests
//
//  Created by Bartosz Król on 01/08/2023.
//

import XCTest
import ComposableArchitecture

@testable import Life_Progress___Calendar

@MainActor
class CreditsTests: XCTestCase {
    
    func testPackageCreditTapped_ShouldOpenURL() async {
        let openURL = OpenURLEffect(handler: { url in
            return false
        })
        let packageCredit = PackageCredit(
            title: "app",
            url: "https://github.com/Bartozo/Life-Progress-iOS"
        )
        let store = TestStore(
            initialState: CreditsReducer.State(),
            reducer: CreditsReducer()
        ) {
            $0.openURL = openURL
        }
        
        await store.send(.packageCreditTapped(packageCredit)).cancel()
    }
}
