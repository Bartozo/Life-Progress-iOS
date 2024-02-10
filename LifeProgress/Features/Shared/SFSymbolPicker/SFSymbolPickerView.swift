//
//  SFSymbolPickerView.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 16/04/2023.
//

import SwiftUI
import ComposableArchitecture
import SymbolPicker

struct SFSymbolPickerView: View {
    @Environment(\.theme) var theme
    
    @Bindable var store: StoreOf<SFSymbolPickerReducer>
    
    var body: some View {
        Button {
            store.send(.showSheet)
        } label: {
            Image(systemName: store.symbolName)
                .font(.title)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
        }
        .foregroundColor(theme.color)
        .sheet(isPresented: $store.isSheetVisible) {
            SymbolPicker(symbol: $store.symbolName)
        }
    }
}

// MARK: - Previews

#Preview {
    SFSymbolPickerView(
        store: Store(initialState: SFSymbolPickerReducer.State()) {
            SFSymbolPickerReducer()
        }
    )
}
