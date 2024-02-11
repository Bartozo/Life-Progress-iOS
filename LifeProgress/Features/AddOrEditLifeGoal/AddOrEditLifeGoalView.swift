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
    
    @Bindable var store: StoreOf<AddOrEditLifeGoalReducer>
    
    var body: some View {
        NavigationStack {
            Form {
                IconSection(store: store)
                TitleSection(store: store)
                DetailsSection(store: store)
                OthersSection(store: store)
                ShareSection(store: store)
            }
            .navigationTitle(store.isEditing ? "Edit Life Goal" : "Add Life Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        store.send(.closeButtonTapped)
                    } label: {
                        Text("Close")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    AddOrSaveButton(store: store)
                }
            }
            .overlay {
                ConfettiView(
                    store: store.scope(
                        state: \.confetti,
                        action: \.confetti
                    )
                )
            }
            .sheet(
                item: $store.scope(state: \.shareLifeGoal, action: \.shareLifeGoal)
            ) { store in
                ShareLifeGoalView(store: store)
            }
        }
        .tint(theme.color)
    }
}

private struct AddOrSaveButton: View {
    let store: StoreOf<AddOrEditLifeGoalReducer>
    
    var body: some View {
        Button {
            store.send(store.isEditing ? .saveButtonTapped : .addButtonTapped)
        } label: {
            Text(store.isEditing ? "Save" : "Add")
        }
        .disabled(store.title.isEmpty)
    }
}

private struct IconSection: View {
    let store: StoreOf<AddOrEditLifeGoalReducer>
    
    var body: some View {
        Section {
            HStack {
                Spacer()
                SFSymbolPickerView(
                    store: store.scope(
                        state: \.sfSymbolPicker,
                        action: \.sfSymbolPicker
                    )
                )
                Spacer()
            }
        }
        .listRowBackground(Color.clear)
    }
}

private struct TitleSection: View {
    @Bindable var store: StoreOf<AddOrEditLifeGoalReducer>
    
    var body: some View {
        Section {
            TextField(
                text: $store.title,
                prompt: Text("Required")
            ) {
                Text("Username")
            }
        } header: {
            Text("Title")
        }
    }
}

private struct DetailsSection: View {
    @Bindable var store: StoreOf<AddOrEditLifeGoalReducer>
    
    var body: some View {
        Section {
            TextField(
                text: $store.details,
                prompt: Text("Optional"),
                axis: .vertical
            ) {
                Text("Details")
            }
            .lineLimit(5)
        } header: {
            Text("Details")
        } footer: {
            Text("Please describe your life goal briefly, capturing the core purpose and the essential milestones that you strive for. This will effectively communicate your objectives and aspirations")
        }
    }
}

private struct OthersSection: View {
    @Environment(\.requestReview) var requestReview
    
    @Bindable var store: StoreOf<AddOrEditLifeGoalReducer>
    
    var body: some View {
        Section {
            Toggle(
                "Mark as completed",
                isOn: $store.isCompleted.animation(.default)
            )
            .onChange(of: store.isCompleted) { oldIsCompleted, newIsCompleted in
                guard store.isCompleted else { return }
                
                requestReview()
            }
            
            
            if store.isCompleted {
                DatePickerView(
                    title: "Accomplished on day",
                    store: store.scope(
                        state: \.datePicker,
                        action: \.datePicker
                    )
                )
            }
        }
    }
}

private struct ShareSection: View {
    let store: StoreOf<AddOrEditLifeGoalReducer>
    
    var body: some View {
        Section {
            if store.isCompleted {
                Button {
                    store.send(.shareLifeGoalButtonTapped)
                } label: {
                    Text("Share Life Goal")
                }
            }
        }
    }
}


// MARK: - Previews

#Preview {
    NavigationStack {
        AddOrEditLifeGoalView(
            store: Store(initialState: AddOrEditLifeGoalReducer.State()) {
                AddOrEditLifeGoalReducer()
            }
        )
    }
}
