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
                  value: viewStore.binding(
                    get: { Double($0.lifeExpectancy) },
                    send: LifeExpectancyReducer.Action.lifeExpectancyChanged
                  ),
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

// MARK: - Previews

struct LifeExpectancyView_Previews: PreviewProvider {
    
    static var previews: some View {
        let store = Store(initialState: LifeExpectancyReducer.State()) {
            LifeExpectancyReducer()
        }
        
        LifeExpectancyView(store: store)
    }
}
