//
//  BirthdayView.swift
//  LifeProgress
//
//  Created by Bartosz Król on 12/03/2023.
//

import SwiftUI
import ComposableArchitecture

struct BirthdayView: View {
    
    @Environment(\.theme) var theme
    
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
                .tint(.gray)
                .foregroundColor(isDatePickerVisible ? theme.color : .primary)
            }
            .onAppear {
                viewStore.send(.onAppear)
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
                        send: BirthdayReducer.Action.changeBirthdayTapped
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

struct BirthdayView_Previews: PreviewProvider {
    
    static var previews: some View {
        let store = Store<BirthdayReducer.State, BirthdayReducer.Action>(
            initialState: BirthdayReducer.State(),
            reducer: BirthdayReducer()
        )
        BirthdayView(store: store)
    }
}
