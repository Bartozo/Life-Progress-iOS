//
//  LifeExpectancyView.swift
//  LifeProgress
//
//  Created by Bartosz Król on 13/03/2023.
//

import SwiftUI
import ComposableArchitecture

struct LifeExpectancyView: View {
    @Environment(\.theme) var theme
    
    @Bindable var store: StoreOf<LifeExpectancyReducer>
    
    var body: some View {
        HStack {
            Text("Life Expectancy")
            Spacer()
            Button {
                store.send(.isSliderVisibleChanged, animation: .default)
            } label: {
                Text("\(store.lifeExpectancy)")
            }
            .buttonStyle(.bordered)
            .tint(.gray)
            .foregroundColor(store.isSliderVisible ? theme.color : .primary)
        }
        .onAppear { store.send(.onAppear) }
        .onTapGesture { store.send(.isSliderVisibleChanged, animation: .default) }
        
        if store.isSliderVisible {
            Slider(
                value: IntDoubleBinding($store.lifeExpectancy).doubleValue,
                in: 0...150,
                onEditingChanged: { editing in
                    guard !editing else { return }
                    
                    store.send(.lifeExpectancySelectionEnded(Double(store.lifeExpectancy)))
                }
            )
            .tint(theme.color)
        }
    }
}

private struct IntDoubleBinding {
    let intValue : Binding<Int>
    
    let doubleValue : Binding<Double>
    
    init(_ intValue : Binding<Int>) {
        self.intValue = intValue
        self.doubleValue = Binding<Double>(
            get: { return Double(intValue.wrappedValue) },
            set: { intValue.wrappedValue = Int($0) }
        )
    }
}

// MARK: - Previews

#Preview {
    LifeExpectancyView(
        store: Store(initialState: LifeExpectancyReducer.State()) {
            LifeExpectancyReducer()
        }
    )
}
