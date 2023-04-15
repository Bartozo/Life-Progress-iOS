//
//  AddOrEditLifeGoalView.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 12/04/2023.
//

import SwiftUI
import ComposableArchitecture
import SymbolPicker

struct AddOrEditLifeGoalView: View {
    
    @Environment(\.theme) var theme
    
    let store: AddOrEditLifeGoalStore
    
    var body: some View {
        NavigationStack {
            WithViewStore(self.store) { viewStore in
                let isEditing = viewStore.isEditing
                
                Form {
                    TitleSection(store: self.store)
                    DetailsSection(store: self.store)
                    OthersSection(store: self.store)
                }
                .navigationTitle(isEditing ? "Edit Life Goal" : "Add Life Goal")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            
                        } label: {
                            Text("Close")
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {

                        } label: {
                            Text(isEditing ? "Save" : "Add")
                        }
                    }
                }
            }
        }
        .tint(theme.color)
    }
}

private struct TitleSection: View {
    
    let store: AddOrEditLifeGoalStore
    
    var body: some View {
        Section {
            WithViewStore(self.store, observe: \.title) { viewStore in
                TextField(
                    text: viewStore.binding(
                        get: { $0 },
                        send: AddOrEditLifeGoalReducer.Action.titleChanged
                    ),
                    prompt: Text("Required")
                ) {
                    Text("Username")
                }
            }
        } header: {
            Text("Title")
        }
    }
}

private struct DetailsSection: View {
    
    let store: AddOrEditLifeGoalStore
    
    var body: some View {
        Section {
            WithViewStore(self.store, observe: \.details) { viewStore in
                TextEditor(
                    text: viewStore.binding(
                        get: { $0 },
                        send: AddOrEditLifeGoalReducer.Action.detailsChanged
                    )
                )
            }
        } header: {
            Text("Details")
        } footer: {
            Text("Please describe your life goal briefly, capturing the core purpose and the essential milestones that you strive for. This will effectively communicate your objectives and aspirations")
        }
    }
}

private struct OthersSection: View {
    
    let store: AddOrEditLifeGoalStore
    
    var body: some View {
        Section {
            WithViewStore(self.store) { viewStore in
                NavigationLink {
                    SymbolPicker(
                        symbol: viewStore.binding(
                            get: \.symbolName,
                            send: AddOrEditLifeGoalReducer.Action.symbolNameChanged
                        )
                    )
                } label: {
                    HStack {
                        Text("Selected icon")
                        Spacer()
                        Image(systemName: viewStore.symbolName)
                    }
                }
                
                Toggle(
                    "Is completed",
                    isOn: viewStore.binding(
                        get: \.isCompleted,
                        send: AddOrEditLifeGoalReducer.Action.isCompletedChanged
                    ).animation(.default)
                )
                
            
                if viewStore.isCompleted {
                    DatePickerView(
                        title: "Accomplished on day",
                        store: self.store.scope(
                            state: \.datePicker,
                            action: AddOrEditLifeGoalReducer.Action.datePicker
                        )
                    )
                }
            }
        }
    }
}


// MARK: - Previews

struct AddOrEditLifeGoalView_Previews: PreviewProvider {
    
    static var previews: some View {
        let store = Store<AddOrEditLifeGoalReducer.State, AddOrEditLifeGoalReducer.Action>(
            initialState: AddOrEditLifeGoalReducer.State(),
            reducer: AddOrEditLifeGoalReducer()
        )
        
        NavigationStack {
            AddOrEditLifeGoalView(store: store)
        }
    }
}
