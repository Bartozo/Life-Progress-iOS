//
//  ThemeView.swift
//  LifeProgress
//
//  Created by Bartosz Król on 15/03/2023.
//

import SwiftUI
import ComposableArchitecture

struct ThemeView: View {
    @Bindable var store: StoreOf<ThemeReducer>
    
    var body: some View {
        Picker(
            "Color",
            selection: $store.selectedTheme
        ) {
            ForEach(store.themes, id: \.self) { theme in
                Label(
                    theme.color.description.capitalized,
                    systemImage:  "circle.fill"
                )
                .labelStyle(.titleAndIcon)
                .foregroundColor(theme.color)
            }
        }
        .pickerStyle(.navigationLink)
        .onAppear { store.send(.onAppear) }
    }
}

struct ThemeApplicator: ViewModifier {
    let store: StoreOf<ThemeReducer>
        
    func body(content: Content) -> some View {
        content.environment(\.theme, store.selectedTheme)
    }
}

// MARK: - Previews

#Preview {
    NavigationStack {
        ThemeView(
            store: Store(initialState: ThemeReducer.State()) {
                ThemeReducer()
            }
        )
    }
}
