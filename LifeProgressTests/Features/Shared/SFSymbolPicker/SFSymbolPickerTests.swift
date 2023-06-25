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
        let store = TestStore(
            initialState: SFSymbolPickerReducer.State(),
            reducer: SFSymbolPickerReducer()
        )
        let symbolName = "book"
        
        await store.send(.symbolNameChanged(symbolName)) {
            $0.symbolName = symbolName
        }
    }
    
    func testShowSheet_ShouldShowSheet() async {
        let store = TestStore(
            initialState: SFSymbolPickerReducer.State(),
            reducer: SFSymbolPickerReducer()
        )
        
        await store.send(.showSheet) {
            $0.isSheetVisible = true
        }
    }
    
    func testHideSheet_ShouldHideSheet() async {
        let store = TestStore(
            initialState: SFSymbolPickerReducer.State(isSheetVisible: true),
            reducer: SFSymbolPickerReducer()
        )
        
        await store.send(.hideSheet) {
            $0.isSheetVisible = false
        }
    }
}

