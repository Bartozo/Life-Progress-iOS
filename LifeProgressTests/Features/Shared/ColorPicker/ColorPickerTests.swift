//
//  ColorPickerTests.swift
//  LifeProgressTests
//
//  Created by Bartosz Król on 06/08/2023.
//

import XCTest
import ComposableArchitecture

@testable import Life_Progress___Calendar

@MainActor
class ColorPickerTests: XCTestCase {
    
    func testColorChanged_ShouldUpdateColor() async {
        let store = TestStore(
            initialState: ColorPickerReducer.State(),
            reducer: ColorPickerReducer()
        )
        let color = ColorPickerReducer.State.Color.blue
        
        await store.send(.colorChanged(color)) {
            $0.color = color
        }
    }
}
