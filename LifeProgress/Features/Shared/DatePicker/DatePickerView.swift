//
//  DatePickerView.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 15/04/2023.
//

import SwiftUI
import ComposableArchitecture

struct DatePickerView: View {
    @Environment(\.theme) var theme
    
    let title: String
    
    @Bindable var store: StoreOf<DatePickerReducer>
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Button {
                store.send(.isDatePickerVisibleChanged, animation: .default)
            } label: {
                Text("\(DateFormatters.medium.string(from: store.date))")
            }
            .buttonStyle(.bordered)
            .tint(.gray)
            .foregroundColor(store.isDatePickerVisible ? theme.color : .primary)
        }
        
        if store.isDatePickerVisible {
            DatePicker(
                "",
                selection: $store.date,
                displayedComponents: .date
            )
            .labelsHidden()
            .datePickerStyle(.graphical)
            .tint(theme.color)
        }
    }
}

// MARK: - Previews

#Preview {
    DatePickerView(
        title: "Selected date",
        store: Store(initialState: DatePickerReducer.State()) {
            DatePickerReducer()
        }
    )
}

