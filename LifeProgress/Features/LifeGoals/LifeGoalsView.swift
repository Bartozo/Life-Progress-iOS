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
    
    struct ViewState: Equatable {
        let isAddLifeGoalSheetVisible: Bool
        let isIAPSheetVisible: Bool
        let isShareLifeGoalSheetVisible: Bool
        
        init(state: LifeGoalsReducer.State) {
            self.isAddLifeGoalSheetVisible = state.isAddLifeGoalSheetVisible
            self.isIAPSheetVisible = state.iap.isSheetVisible
            self.isShareLifeGoalSheetVisible = state.isShareLifeGoalSheetVisible
        }
    }
    
    var body: some View {
        WithViewStore(self.store, observe: ViewState.init) { viewStore in
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
                    get: \.isIAPSheetVisible,
                    send: LifeGoalsReducer.Action.iap(.hideSheet)
                )) {
                    IAPView(
                        store: self.store.scope(
                            state: \.iap,
                            action: LifeGoalsReducer.Action.iap
                        )
                    )
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
                .sheet(isPresented: viewStore.binding(
                    get: \.isShareLifeGoalSheetVisible,
                    send: LifeGoalsReducer.Action.closeShareLifeGoalSheet
                )) {
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

struct LifeGoalsView_Previews: PreviewProvider {
    
    static var previews: some View {
        let store = Store(initialState: LifeGoalsReducer.State()) {
            LifeGoalsReducer()
        }
        
        NavigationStack {
            LifeGoalsView(store: store)
        }
    }
}

