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
                .sheet(isPresented: viewStore.$isAddLifeGoalSheetVisible) {
                    IfLetStore(
                        self.store.scope(
                            state: \.addOrEditLifeGoal,
                            action: LifeGoalsReducer.Action.addOrEditLifeGoal
                        )
                    ) {
                        AddOrEditLifeGoalView(store: $0)
                    }
                }
                .sheet(isPresented: viewStore.$isShareLifeGoalSheetVisible) {
                    IfLetStore(
                        self.store.scope(
                            state: \.shareLifeGoal,
                            action: LifeGoalsReducer.Action.shareLifeGoal
                        )
                    ) {
                        ShareLifeGoalView(store: $0)
                    }
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


// MARK: - Previews

#Preview {
    let store = Store(initialState: LifeGoalsReducer.State()) {
        LifeGoalsReducer()
    }
    
    return NavigationStack {
        LifeGoalsView(store: store)
    }
}
