//
//  ColorPickerView.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 06/08/2023.
//

import SwiftUI
import ComposableArchitecture

struct ColorPickerView: View {
    
    @Environment(\.theme) var theme
    
    let store: StoreOf<ColorPickerReducer>
    
    private var gridItems: [GridItem] {
        [GridItem(.adaptive(minimum:50, maximum: 70))]
    }
    
    var body: some View {
        WithViewStore(self.store, observe: \.color) { viewStore in
            LazyVGrid(columns: gridItems, spacing: 8) {
                ForEach(ColorPickerReducer.State.Color.allCases) { color in
                    ZStack {
                        if viewStore.state == color {
                            Circle()
                                .stroke(color.colorValue, lineWidth: 3)
                                .frame(width: 50, height: 50)
                        }
                        
                        Circle()
                           .fill(color.colorValue.gradient)
                           .frame(width: 40, height: 40)
                           .tag(color)
                           .onTapGesture {
                               viewStore.send(.colorChanged(color))
                           }
                    }
                    .frame(width: 50, height: 50)
                }
            }
        }
    }
}

// MARK: - Previews

struct ColorPickerView_Previews: PreviewProvider {
    
    static var previews: some View {
        let store = Store(initialState: ColorPickerReducer.State()) {
            ColorPickerReducer()
        }
        
        ColorPickerView(store: store)
    }
}
