//
//  LifeGoalsView.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 11/04/2023.
//

import SwiftUI
import ComposableArchitecture

struct LifeGoalsView: View {
    
    let store: LifeGoalsStore
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            List {
                Section {
                    ForEach(1..<40) { index in
                       Text("Row #\(index)")
                     }
                } header: {
                    Picker(
                        "",
                        selection: viewStore.binding(
                            get: \.listType,
                            send: LifeGoalsReducer.Action.listTypeChanged
                        )
                    ) {
                        ForEach(LifeGoalsReducer.ListType.allCases, id: \.self) {
                            listType in
                            let _ = print(listType.title)
                            Text(listType.title)
                                .tag(listType)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Life Goals")
            .toolbar {
                  ToolbarItem(placement: .navigationBarTrailing) {
                      Button(action: {
                          viewStore.send(.addButtonTapped)
                      }) {
                          Image(systemName: "plus.circle.fill")
                      }
                  }
              }
            .sheet(isPresented: viewStore.binding(
                get: \.isAddLifeGoalSheetVisible,
                send: LifeGoalsReducer.Action.closeAddLifeGoalSheet
            )) {
                IfLetStore(
                    self.store.scope(
                        state: \.addOrEditLifeGoal,
                        action: LifeGoalsReducer.Action.addOrEditLifeGoal
                    )
                ) {
                    AddOrEditLifeGoalView(store: $0)
                }
            }
        }
    }
}

// MARK: - Previews

struct LifeGoalsView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store<LifeGoalsReducer.State, LifeGoalsReducer.Action>(
            initialState: LifeGoalsReducer.State(), reducer: LifeGoalsReducer())
        NavigationStack {
            LifeGoalsView(store: store)
        }
    }
}
