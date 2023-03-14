//
//  BirthdayView.swift
//  LifeProgress
//
//  Created by Bartosz Król on 12/03/2023.
//

import SwiftUI
import ComposableArchitecture

struct BirthdayView: View {
    let store: BirthdayStore

    var body: some View {
        WithViewStore(self.store) { viewStore in
            let isDatePickerVisible = viewStore.isDatePickerVisible
            
            HStack {
                Text("Your Birthday")
                Spacer()
                Button {
                    viewStore.send(
                        .isDatePickerVisibleChanged,
                        animation: .default
                    )
                } label: {
                    Text("\(DateFormatters.medium.string(from: viewStore.birthday))")
                }
                .buttonStyle(.bordered)
                .foregroundColor(isDatePickerVisible ? .blue : .primary)
            }
            .onTapGesture {
                viewStore.send(
                    .isDatePickerVisibleChanged,
                    animation: .default
                )
            }
            
            if isDatePickerVisible {
                DatePicker(
                    "",
                    selection: viewStore.binding(
                        get: \.birthday,
                        send: BirthdayReducer.Action.birthdayChanged
                    ),
                    displayedComponents: .date
                )
                .labelsHidden()
                .datePickerStyle(.graphical)
            }
        }
    }
}

// MARK: - Previews

struct BirthdayView_Previews: PreviewProvider {
    
    static var previews: some View {
        let store = Store<BirthdayReducer.State, BirthdayReducer.Action>(
            initialState: BirthdayReducer.State(),
            reducer: BirthdayReducer()
        )
        BirthdayView(store: store)
    }
}
