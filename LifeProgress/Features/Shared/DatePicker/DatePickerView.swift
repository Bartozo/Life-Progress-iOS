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
    
    init(title: String, store: StoreOf<DatePickerReducer>) {
        self.title = title
        self.store = store
    }
    
    let store: StoreOf<DatePickerReducer>
    let title: String

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
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
                .tint(.gray)
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
        let store = Store(initialState: DatePickerReducer.State()) {
            DatePickerReducer()
        }
        
        DatePickerView(title: "Selected date", store: store)
    }
}
