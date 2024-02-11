//
//  ColorPickerView.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 06/08/2023.
//

import SwiftUI
import ComposableArchitecture

struct ColorPickerView: View {
    
    let store: StoreOf<ColorPickerReducer>
    
    private var gridItems: [GridItem] {
        [GridItem(.adaptive(minimum:50, maximum: 70))]
    }
    
    var body: some View {
        LazyVGrid(columns: gridItems, spacing: 8) {
            ForEach(ColorPickerReducer.State.Color.allCases) { color in
                ZStack {
                    if store.color == color {
                        Circle()
                            .stroke(color.colorValue, lineWidth: 3)
                            .frame(width: 50, height: 50)
                    }
                    
                    Circle()
                       .fill(color.colorValue.gradient)
                       .frame(width: 40, height: 40)
                       .tag(color)
                       .onTapGesture {
                           store.send(.colorChanged(color))
                       }
                }
                .frame(width: 50, height: 50)
            }
        }
    }
}

// MARK: - Previews

#Preview {
    ColorPickerView(
        store: Store(initialState: ColorPickerReducer.State()) {
            ColorPickerReducer()
        }
    )
}
