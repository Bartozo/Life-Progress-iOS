//
//  ThemeView.swift
//  LifeProgress
//
//  Created by Bartosz Król on 15/03/2023.
//

import SwiftUI
import ComposableArchitecture

struct ThemeView: View {
    let store: ThemeStore
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            Picker(
                "Color",
                selection: viewStore.binding(
                    get: { $0.selectedTheme.color },
                    send: ThemeReducer.Action.themeChanged
                )
            ) {
                ForEach(viewStore.themes, id: \.self) { color in
                    Label(
                        color.description.capitalized,
                        systemImage:  "circle.fill"
                    )
                    .labelStyle(.titleAndIcon)
                    .foregroundColor(color)
                }
            }
            .pickerStyle(.navigationLink)
        }
    }
}

struct ThemeApplicator: ViewModifier {
    
    let store: Store<ThemeReducer.State, Never>
        
    func body(content: Content) -> some View {
        WithViewStore(self.store) { viewStore in
            content.environment(\.theme, viewStore.selectedTheme)
        }
    }
}

// MARK: - Previews

struct ThemeView_Previews: PreviewProvider {
    
    static var previews: some View {
        let store = Store<ThemeReducer.State, ThemeReducer.Action>(
            initialState: ThemeReducer.State(),
            reducer: ThemeReducer()
        )
        ThemeView(store: store)
    }
}
