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
    
    init(title: String, store: DatePickerStore) {
        self.title = title
        self.store = store
    }
    
    let store: DatePickerStore
    let title: String

    var body: some View {
        WithViewStore(self.store) { viewStore in
            let isDatePickerVisible = viewStore.isDatePickerVisible
            
            HStack {
                Text(title)
                Spacer()
                Button {
                    viewStore.send(
                        .isDatePickerVisibleChanged,
                        animation: .default
                    )
                } label: {
                    Text("\(DateFormatters.medium.string(from: viewStore.date))")
                }
                .buttonStyle(.bordered)
                .foregroundColor(isDatePickerVisible ? theme.color : .primary)
            }
            
            if isDatePickerVisible {
                DatePicker(
                    "",
                    selection: viewStore.binding(
                        get: \.date,
                        send: DatePickerReducer.Action.dateChanged
                    ),
                    displayedComponents: .date
                )
                .labelsHidden()
                .datePickerStyle(.graphical)
                .tint(theme.color)
            }
        }
    }
}

// MARK: - Previews

struct DatePickerView_Previews: PreviewProvider {
    
    static var previews: some View {
        let store = Store<DatePickerReducer.State, DatePickerReducer.Action>(
            initialState: DatePickerReducer.State(),
            reducer: DatePickerReducer()
        )
        DatePickerView(title: "Selected date", store: store)
    }
}
