//
//  LifeCalendarView.swift
//  LifeProgress
//
//  Created by Bartosz Król on 10/03/2023.
//

import SwiftUI
import ComposableArchitecture

struct LifeCalendarView: View {
    
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    
    let store: StoreOf<LifeCalendarReducer>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            calendarContent
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Picker(
                            "",
                            selection: viewStore.$calendarType
                        ) {
                            ForEach(LifeCalendarReducer.State.CalendarType.allCases, id: \.self) { calendarType in
                                Text(calendarType.title)
                                    .tag(calendarType)
                            }
                        }
                        .pickerStyle(.segmented)
                        .scaledToFit()
                    }
                }
                .navigationTitle("Life Calendar")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        PremiumButton(
                            store: self.store.scope(
                                state: \.iap,
                                action: LifeCalendarReducer.Action.iap
                            )
                        )
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            viewStore.send(.aboutLifeCalendarButtonTapped)
                        }) {
                            Image(systemName: "questionmark.circle")
                        }
                    }
                }
                .sheet(
                    store: self.store.scope(
                        state: \.$aboutTheApp,
                        action: { .aboutTheApp($0) }
                    )
                ) { store in
                    AboutTheAppView(store: store)
                }
        }
    }
    
    @ViewBuilder
    private var calendarContent: some View {
        if verticalSizeClass == .regular {
            calendar
        } else {
            ScrollView(showsIndicators: false) {
                calendar
            }
        }
    }
    
    private var calendar: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            let life = viewStore.life
            let calendarType = viewStore.calendarType
            let currentYearModeColumnCount = viewStore.currentYearModeColumnCount
            
            let fullCalendarAspectRatio = Double(Life.totalWeeksInAYear) / Double(life.lifeExpectancy)
            let currentYearGridAspectRatio = Double(currentYearModeColumnCount) / (Double(Life.totalWeeksInAYear) / Double(currentYearModeColumnCount) + 1)
            
            ZStack(alignment: .topLeading) {
                CalendarWithoutCurrentYear(store: self.store)
                CalendarWithCurrentYear(store: self.store)
            }
            .aspectRatio(
                min(fullCalendarAspectRatio, currentYearGridAspectRatio),
                contentMode: .fit
            )
            .onTapGesture {
                viewStore.send(.calendarTypeChanged(
                    calendarType == .currentYear ? .life : .currentYear)
                )
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}

// MARK: - Previews

#Preview {
    let store = Store(initialState: LifeCalendarReducer.State()) {
        LifeCalendarReducer()
    }
    
    return LifeCalendarView(store: store)
}
