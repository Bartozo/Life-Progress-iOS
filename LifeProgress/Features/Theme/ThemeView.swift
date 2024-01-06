//
//  ThemeView.swift
//  LifeProgress
//
//  Created by Bartosz Król on 15/03/2023.
//

import SwiftUI
import ComposableArchitecture

struct ThemeView: View {
    let store: StoreOf<ThemeReducer>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Picker(
                "Color",
                selection: viewStore.$selectedTheme
            ) {
                ForEach(viewStore.themes, id: \.self) { theme in
                    Label( 
                        theme.color.description.capitalized,
                        systemImage:  "circle.fill"
                    )
                    .labelStyle(.titleAndIcon)
                    .foregroundColor(theme.color)
                }
            }
            .pickerStyle(.navigationLink)
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}

struct ThemeApplicator: ViewModifier {
    
    let store: StoreOf<ThemeReducer>
        
    func body(content: Content) -> some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            content.environment(\.theme, viewStore.selectedTheme)
        }
    }
}

// MARK: - Previews

#Preview {
    let store = Store(initialState: ThemeReducer.State()) {
        ThemeReducer()
    }
    
    return NavigationStack {
        ThemeView(store: store)
    }
}
