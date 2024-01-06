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
    
    let store: StoreOf<BirthdayReducer>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
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
                    selection: viewStore.$birthday,
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

#Preview {
    let store = Store(initialState: BirthdayReducer.State()) {
        BirthdayReducer()
    }
    
    return BirthdayView(store: store)
}
