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
            WithViewStore(self.store, observe: \.isEditing) { viewStore in
                let isEditing = viewStore.state
                
                Form {
                    IconSection(store: self.store)
                    TitleSection(store: self.store)
                    DetailsSection(store: self.store)
                    OthersSection(store: self.store)
                }
                .navigationTitle(isEditing ? "Edit Life Goal" : "Add Life Goal")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            viewStore.send(.closeButtonTapped)
                        } label: {
                            Text("Close")
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            viewStore.send(isEditing ? .saveButtonTapped : .addButtonTapped)
                        } label: {
                            Text(isEditing ? "Save" : "Add")
                        }
                    }
                }
                .overlay {
                    ConfettiView(store: self.store.scope(
                        state: \.confetti,
                        action: AddOrEditLifeGoalReducer.Action.confetti
                    ))
                }
            }
        }
        .tint(theme.color)
    }
}

private struct IconSection: View {
    
    let store: AddOrEditLifeGoalStore
    
    var body: some View {
        Section {
            HStack {
                Spacer()
                SFSymbolPickerView(
                    store: self.store.scope(
                        state: \.sfSymbolPicker,
                        action: AddOrEditLifeGoalReducer.Action.sfSymbolPicker
                    )
                )
                Spacer()
            }
        }
        .listRowBackground(Color.clear)
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
                .frame(maxHeight: 150)
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
            WithViewStore(self.store, observe: \.isCompleted) { viewStore in
                let isCompleted = viewStore.state
                
                Toggle(
                    "Mark as completed",
                    isOn: viewStore.binding(
                        get: { $0 },
                        send: AddOrEditLifeGoalReducer.Action.isCompletedChanged
                    ).animation(.default)
                )
            
                if isCompleted {
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
