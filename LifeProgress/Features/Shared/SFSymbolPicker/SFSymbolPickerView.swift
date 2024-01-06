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

    let store: StoreOf<SFSymbolPickerReducer>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            let symbolName = viewStore.symbolName
            
            Button {
                viewStore.send(.showSheet)
            } label: {
                Image(systemName: symbolName)
                    .font(.title)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }
            .foregroundColor(theme.color)
            .sheet(isPresented: viewStore.$isSheetVisible) {
                SymbolPicker(symbol: viewStore.$symbolName)
            }
        }
    }
}

// MARK: - Previews

#Preview {
    let store = Store(initialState: SFSymbolPickerReducer.State()) {
        SFSymbolPickerReducer()
    }
    
    return SFSymbolPickerView(store: store)
}
