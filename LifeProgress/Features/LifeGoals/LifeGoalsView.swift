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
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.createdAt)])
    var lifeGoalEntities: FetchedResults<LifeGoalEntity>
    
    var body: some View {
        WithViewStore(self.store, observe: \.isAddLifeGoalSheetVisible) { viewStore in
            let isAddLifeGoalSheetVisible = viewStore.state
            
            LifeGoalsList(store: self.store)
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
                    get: { _ in isAddLifeGoalSheetVisible },
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
                .onReceive(lifeGoalEntities.publisher) { _ in
                    viewStore.send(.onAppear, animation: .default)
                }
        }
    }
}

private struct LifeGoalsList: View {

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

struct LifeGoalsView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store<LifeGoalsReducer.State, LifeGoalsReducer.Action>(
            initialState: LifeGoalsReducer.State(), reducer: LifeGoalsReducer())
        NavigationStack {
            LifeGoalsView(store: store)
        }
    }
}

