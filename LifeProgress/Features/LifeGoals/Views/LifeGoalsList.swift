//
//  LifeGoalsList.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 01/05/2023.
//

import SwiftUI
import ComposableArchitecture

struct LifeGoalsList: View {

    let store: LifeGoalsStore
    
    struct ViewState: Equatable {
        let listType: LifeGoalsReducer.ListType
        let lifeGoals: [LifeGoal]
        
        init(state: LifeGoalsReducer.State) {
            self.listType = state.listType
            self.lifeGoals = state.filteredLifeGoals
        }
    }

    var body: some View {
        WithViewStore(self.store, observe: ViewState.init) { viewStore in
            List {
                Section {
                    ForEach(viewStore.lifeGoals, id: \.id) { lifeGoal in
                        Button {
                            viewStore.send(.lifeGoalTapped(lifeGoal))
                        } label: {
                            LifeGoalRow(lifeGoal: lifeGoal)
                                .swipeActions(allowsFullSwipe: false) {
                                    Button(role: .destructive) {
                                        viewStore.send(.swipeToDelete(lifeGoal))
                                    } label: {
                                        Label("Delete", systemImage: "trash.fill")
                                    }
                                    
                                    if lifeGoal.isCompleted {
                                        Button {
                                            viewStore.send(.swipeToUncomplete(lifeGoal), animation: .default)
                                        } label: {
                                            Label("Uncomplete", systemImage: "xmark.circle.fill")
                                        }
                                    } else {
                                        Button {
                                            viewStore.send(.swipeToComplete(lifeGoal), animation: .default)
                                        } label: {
                                            Label("Complete", systemImage: "checkmark.circle.fill")
                                        }
                                        .tint(.green)
                                    }
                                }
                        }
                    }
                } header: {
                    Picker(
                        "",
                        selection: viewStore.binding(
                            get: \.listType,
                            send: LifeGoalsReducer.Action.listTypeChanged
                        )
                        .animation()
                    ) {
                        ForEach(LifeGoalsReducer.ListType.allCases, id: \.self) {
                            listType in
                            Text(listType.title)
                                .tag(listType)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .listStyle(.plain)
        }
    }
}

private struct LifeGoalRow: View {
    let lifeGoal: LifeGoal

    var body: some View {
        HStack {
            Image(systemName: lifeGoal.symbolName)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .padding(.trailing, 10)

            VStack(alignment: .leading) {
                Text(lifeGoal.title)
                    .font(.headline)
                    .lineLimit(2)

                Text(lifeGoal.details)
                    .lineLimit(2)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}

// MARK: - Previews

struct LifeGoalsList_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store<LifeGoalsReducer.State, LifeGoalsReducer.Action>(
            initialState: LifeGoalsReducer.State(),
            reducer: LifeGoalsReducer()
        )
        LifeGoalsList(store: store)
    }
}
