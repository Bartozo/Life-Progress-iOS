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
    
    let store: StoreOf<LifeExpectancyReducer>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            let isSliderVisible = viewStore.isSliderVisible
            let lifeExpectancy = viewStore.lifeExpectancy
            
            HStack {
                Text("Life Expectancy")
                Spacer()
                Button {
                    viewStore.send(
                        .isSliderVisibleChanged,
                        animation: .default
                    )
                } label: {
                    Text("\(lifeExpectancy)")
                }
                .buttonStyle(.bordered)
                .tint(.gray)
                .foregroundColor(isSliderVisible ? theme.color : .primary)
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
            .onTapGesture {
                viewStore.send(
                    .isSliderVisibleChanged,
                    animation: .default
                )
            }
            
            if isSliderVisible {
                Slider(
                    value: IntDoubleBinding(viewStore.$lifeExpectancy).doubleValue,
                    in: 0...150,
                    onEditingChanged: { editing in
                        guard !editing else { return }
                        
                        viewStore.send(.lifeExpectancySelectionEnded(Double(viewStore.lifeExpectancy)))
                    }
                )
                .tint(theme.color)
            }
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
    let store = Store(initialState: LifeExpectancyReducer.State()) {
        LifeExpectancyReducer()
    }
    
    return LifeExpectancyView(store: store)
}
