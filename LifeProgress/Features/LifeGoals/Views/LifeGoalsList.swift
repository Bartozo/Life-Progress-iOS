//
//  LifeGoalsList.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 01/05/2023.
//

import SwiftUI
import ComposableArchitecture
import StoreKit

struct LifeGoalsList: View {
    @Environment(\.requestReview) var requestReview
    
    @Environment(\.theme) var theme
    
    let store: StoreOf<LifeGoalsReducer>
    
    var body: some View {
        List {
            ForEach(store.filteredLifeGoals, id: \.id) { lifeGoal in
                LifeGoalRow(
                    lifeGoal: lifeGoal,
                    onTapped: { store.send(.lifeGoalTapped(lifeGoal)) }
                )
                .swipeActions(allowsFullSwipe: false) {
                    Button(role: .destructive) {
                        store.send(.swipeToDelete(lifeGoal))
                    } label: {
                        Label("Delete", systemImage: "trash.fill")
                    }
                    
                    if lifeGoal.isCompleted {
                        Button {
                            store.send(.swipeToUncomplete(lifeGoal))
                        } label: {
                            Label("Uncomplete", systemImage: "xmark.circle.fill")
                        }
                        Button {
                            store.send(.swipeToShare(lifeGoal))
                        } label: {
                            Label("Share", systemImage: "square.and.arrow.up.fill")
                        }
                        .tint(theme.color)
                    } else {
                        Button {
                            store.send(.swipeToComplete(lifeGoal))
                            requestReview()
                        } label: {
                            Label("Complete", systemImage: "checkmark.circle.fill")
                        }
                        .tint(.green)
                    }
                }
                .onTapGesture {
                    store.send(.lifeGoalTapped(lifeGoal))
                }
            }
        }
        .listStyle(.insetGrouped)
        .overlay {
            if store.filteredLifeGoals.isEmpty {
                GeometryReader { geometry in
                    VStack {
                        switch store.listType {
                        case .completed:
                            EmptyLifeGoalsCompletedList()
                            
                        case .uncompleted:
                            EmptyLifeGoalsUncompletedList()
                        }
                    }
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height
                    )
                }
            }
        }
    }
}

private struct EmptyLifeGoalsCompletedList: View {
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            VStack(spacing: 10) {
                Image(systemName: "checkmark.circle")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
                
                Text("No Completed Goals")
                    .font(.callout)
                    .foregroundColor(.gray)
            }
            
            Text("You haven't marked any goals as completed yet. Keep working towards your objectives and celebrate your achievements here.")
                .multilineTextAlignment(.center)
                .font(.footnote)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: 300)
    }
}

private struct EmptyLifeGoalsUncompletedList: View {
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            VStack(spacing: 10) {
                Image(systemName: "square.and.pencil")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
                
                Text("No Active Goals")
                    .font(.callout)
                    .foregroundColor(.gray)
            }
            
            Text("You haven't set any goals yet. Start setting your objectives to track your progress and achieve personal growth.")
                .multilineTextAlignment(.center)
                .font(.footnote)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: 300)
    }
}


private struct LifeGoalRow: View {
    let lifeGoal: LifeGoal
    
    let onTapped: () -> Void
    
    var body: some View {
        Button(action: onTapped) {
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
                        .foregroundColor(.primary)
                    
                    Text(lifeGoal.details)
                        .lineLimit(2)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

// MARK: - Previews

#Preview {
    LifeGoalsList(
        store: Store(initialState: LifeGoalsReducer.State()) {
            LifeGoalsReducer()
        }
    )
}
