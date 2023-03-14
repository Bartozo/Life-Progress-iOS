//
//  WeeklyNotificationView.swift
//  LifeProgress
//
//  Created by Bartosz Król on 13/03/2023.
//

import SwiftUI
import ComposableArchitecture

struct WeeklyNotificationView: View {
    let store: WeeklyNotificationStore
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            Toggle(
                "Weekly Notification",
                isOn: viewStore.binding(
                    get: \.isWeeklyNotificationEnabled,
                    send: WeeklyNotificationReducer.Action.isWeeklyNotificationChanged
                )
            )
        }
    }
}

// MARK: - Previews

struct WeeklyNotificationView_Previews: PreviewProvider {
    
    static var previews: some View {
        let store = Store<WeeklyNotificationReducer.State, WeeklyNotificationReducer.Action>(
            initialState: WeeklyNotificationReducer.State(),
            reducer: WeeklyNotificationReducer()
        )
        WeeklyNotificationView(store: store)
    }
}
