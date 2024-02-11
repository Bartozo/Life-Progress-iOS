//
//  SFSymbolPickerTests.swift
//  LifeProgressTests
//
//  Created by Bartosz Król on 25/06/2023.
//

import XCTest
import ComposableArchitecture

@testable import Life_Progress___Calendar

@MainActor
class SFSymbolPickerTests: XCTestCase {
    
    func testSymbolNameChanged_ShouldUpdateSymbol() async {
        let store = TestStore(initialState: SFSymbolPickerReducer.State()) {
            SFSymbolPickerReducer()
        }
        let symbolName = "book"
        
        await store.send(.set(\.symbolName, symbolName)) {
            $0.symbolName = symbolName
        }
    }
    
    func testShowSheet_ShouldShowSheet() async {
        let store = TestStore(initialState: SFSymbolPickerReducer.State()) {
            SFSymbolPickerReducer()
        }
        
        await store.send(.showSheet) {
            $0.isSheetVisible = true
        }
    }
}

