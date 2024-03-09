//
//  ColorGradientBackground.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 09/03/2024.
//

import SwiftUI
import ComposableArchitecture

struct ColorGradientBackground: View {
    
    let store: StoreOf<ColorPickerReducer>
    
    var body: some View {
        Rectangle()
            .fill(store.color.colorValue.gradient)
    }
}

#Preview {
    ColorGradientBackground(
        store: Store(initialState: ColorPickerReducer.State()) {
            ColorPickerReducer()
        }
    )
}
