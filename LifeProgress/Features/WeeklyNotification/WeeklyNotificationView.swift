//
//  WeeklyNotificationView.swift
//  LifeProgress
//
//  Created by Bartosz Król on 13/03/2023.
//

import SwiftUI
import ComposableArchitecture

struct WeeklyNotificationView: View {
    @Bindable var store: StoreOf<WeeklyNotificationReducer>
    
    var body: some View {
        Toggle(
            "Weekly Notification",
            isOn: $store.isWeeklyNotificationEnabled
        )
    }
}

// MARK: - Previews

#Preview {
    WeeklyNotificationView(
        store: Store(initialState: WeeklyNotificationReducer.State()) {
            WeeklyNotificationReducer()
        }
    )
}
