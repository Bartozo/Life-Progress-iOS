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
    
    @Bindable var store: StoreOf<LifeCalendarReducer>
    
    var body: some View {
        calendarContent
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Picker(
                        "",
                        selection: $store.calendarType
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
                        store: store.scope(
                            state: \.iap,
                            action: \.iap
                        )
                    )
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        store.send(.aboutLifeCalendarButtonTapped)
                    }) {
                        Image(systemName: "questionmark.circle")
                    }
                }
            }
            .sheet(
                item: $store.scope(state: \.aboutTheApp, action: \.aboutTheApp)
            ) { store in
                AboutTheAppView(store: store)
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
    
    @ViewBuilder
    private var calendar: some View {
        let life = store.life
        let calendarType = store.calendarType
        let currentYearModeColumnCount = store.currentYearModeColumnCount
        
        let fullCalendarAspectRatio = Double(Life.totalWeeksInAYear) / Double(life.lifeExpectancy)
        let currentYearGridAspectRatio = Double(currentYearModeColumnCount) / (Double(Life.totalWeeksInAYear) / Double(currentYearModeColumnCount) + 1)
        
        ZStack(alignment: .topLeading) {
            CalendarWithoutCurrentYear(store: store)
            CalendarWithCurrentYear(store: store)
        }
        .aspectRatio(
            min(fullCalendarAspectRatio, currentYearGridAspectRatio),
            contentMode: .fit
        )
        .onTapGesture {
            store.send(.calendarTypeChanged(
                calendarType == .currentYear ? .life : .currentYear)
            )
        }
        .onAppear { store.send(.onAppear) }
    }
}

// MARK: - Previews

#Preview {
    LifeCalendarView(
        store: Store(initialState: LifeCalendarReducer.State()) {
            LifeCalendarReducer()
        }
    )
}
