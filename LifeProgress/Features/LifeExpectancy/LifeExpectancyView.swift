//
//  LifeExpectancyView.swift
//  LifeProgress
//
//  Created by Bartosz Król on 13/03/2023.
//

import SwiftUI
import ComposableArchitecture

struct LifeExpectancyView: View {
    let store: LifeExpectancyStore

    var body: some View {
        Form {
            WithViewStore(self.store) { viewStore in
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
                    .foregroundColor(isSliderVisible ? .blue : .primary)
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
                      in: 0...150
                    )
                }
                Text("Another label just for test :]")
            }
        }
    }
}

struct LifeExpectancyView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store<LifeExpectancyReducer.State, LifeExpectancyReducer.Action>(
            initialState: LifeExpectancyReducer.State(),
            reducer: LifeExpectancyReducer()
        )
        LifeExpectancyView(store: store)
    }
}
