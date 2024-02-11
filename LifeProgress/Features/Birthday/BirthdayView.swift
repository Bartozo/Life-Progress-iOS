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
    
    @Bindable var store: StoreOf<BirthdayReducer>

    var body: some View {
        HStack {
            Text("Your Birthday")
            Spacer()
            Button {
                store.send(.isDatePickerVisibleChanged, animation: .default)
            } label: {
                Text("\(DateFormatters.medium.string(from: store.birthday))")
            }
            .buttonStyle(.bordered)
            .tint(.gray)
            .foregroundColor(store.isDatePickerVisible ? theme.color : .primary)
        }
        .onAppear { store.send(.onAppear) }
        .onTapGesture {
            store.send(.isDatePickerVisibleChanged, animation: .default)
        }
        
        if store.isDatePickerVisible {
            DatePicker(
                "",
                selection: $store.birthday,
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
    BirthdayView(
        store: Store(initialState: BirthdayReducer.State()) {
            BirthdayReducer()
        }
    )
}
