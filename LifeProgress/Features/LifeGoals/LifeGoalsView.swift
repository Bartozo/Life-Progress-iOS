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
    @Bindable var store: StoreOf<LifeGoalsReducer>
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.createdAt)])
    var lifeGoalEntities: FetchedResults<LifeGoalEntity>
    
    var body: some View {
        LifeGoalsList(store: store)
            .navigationTitle("Life Goals")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    PremiumButton(
                        store: store.scope(
                            state: \.iap,
                            action: \.iap
                        )
                    )
                }
                ToolbarItem(placement: .principal) {
                    ListTypePicker(store: store)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        store.send(.addButtonTapped)
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
            .sheet(
                item: $store.scope(state: \.addOrEditLifeGoal, action: \.addOrEditLifeGoal)
            ) { store in
                AddOrEditLifeGoalView(store: store)
            }
            .sheet(
                item: $store.scope(state: \.shareLifeGoal, action: \.shareLifeGoal)
            ) { store in
                ShareLifeGoalView(store: store)
            }
            .onReceive(lifeGoalEntities.publisher) { _ in
                store.send(.onAppear, animation: .default)
            }
            .onAppear {
                store.send(.onAppear, animation: .default)
                store.send(.iap(.refreshPurchasedProducts))
            }
            .overlay {
                ConfettiView(
                    store: store.scope(
                        state: \.confetti,
                        action: \.confetti
                    )
                )
            }
    }
}

private struct ListTypePicker: View {
    @Bindable var store: StoreOf<LifeGoalsReducer>
    
    var body: some View {
        Picker(
            "",
            selection: $store.listType.animation()
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

// MARK: - Previews

#Preview {
    NavigationStack {
        LifeGoalsView(
            store: Store(initialState: LifeGoalsReducer.State()) {
                LifeGoalsReducer()
            }
        )
    }
}
