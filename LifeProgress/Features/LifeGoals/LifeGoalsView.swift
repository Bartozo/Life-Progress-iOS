//
//  LifeGoalsView.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 11/04/2023.
//

import SwiftUI
import ComposableArchitecture
import ConfettiSwiftUI

struct LifeGoalsView: View {
    
    let store: StoreOf<LifeGoalsReducer>
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.createdAt)])
    var lifeGoalEntities: FetchedResults<LifeGoalEntity>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            LifeGoalsList(store: self.store)
                .navigationTitle("Life Goals")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        PremiumButton(
                            store: self.store.scope(
                                state: \.iap,
                                action: LifeGoalsReducer.Action.iap
                            )
                        )
                    }
                    ToolbarItem(placement: .principal) {
                        ListTypePicker(store: self.store)
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            viewStore.send(.addButtonTapped)
                        }) {
                            Image(systemName: "plus.circle.fill")
                        }
                    }
                }
                .sheet(isPresented: viewStore.binding(
                    get: \.iap.isSheetVisible,
                    send: LifeGoalsReducer.Action.iap(.hideSheet)
                )) {
                    IAPView(
                        store: self.store.scope(
                            state: \.iap,
                            action: LifeGoalsReducer.Action.iap
                        )
                    )
                }
                .sheet(
                    store: self.store.scope(
                        state: \.$addOrEditLifeGoal,
                        action: { .addOrEditLifeGoal($0) }
                    )
                ) { store in
                    AddOrEditLifeGoalView(store: store)
                }
                .sheet(
                    store: self.store.scope(
                        state: \.$shareLifeGoal,
                        action: { .shareLifeGoal($0) }
                    )
                ) { store in
                    ShareLifeGoalView(store: store)
                }
                .onReceive(lifeGoalEntities.publisher) { _ in
                    viewStore.send(.onAppear, animation: .default)
                }
                .onAppear {
                    viewStore.send(.onAppear, animation: .default)
                    viewStore.send(.iap(.refreshPurchasedProducts))
                }
                .overlay {
                    ConfettiView(store: self.store.scope(
                        state: \.confetti,
                        action: LifeGoalsReducer.Action.confetti
                    ))
                }
        }
    }
}

private struct ListTypePicker: View {
    
    let store: StoreOf<LifeGoalsReducer>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Picker(
                "",
                selection: viewStore.$listType.animation()
            ) {
                ForEach(LifeGoalsReducer.ListType.allCases, id: \.self) {
                    listType in
                    Text(listType.title)
                        .tag(listType)
                }
            }
            .pickerStyle(.segmented)
            .fixedSize()
        }
    }
}

// MARK: - Previews

#Preview {
    let store = Store(initialState: LifeGoalsReducer.State()) {
        LifeGoalsReducer()
    }
    
    return NavigationStack {
        LifeGoalsView(store: store)
    }
}
