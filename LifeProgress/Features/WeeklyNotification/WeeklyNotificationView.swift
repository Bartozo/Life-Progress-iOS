//
//  WeeklyNotificationView.swift
//  LifeProgress
//
//  Created by Bartosz Król on 13/03/2023.
//

import SwiftUI
import ComposableArchitecture

struct WeeklyNotificationView: View {
    let store: StoreOf<WeeklyNotificationReducer>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Toggle(
                "Weekly Notification",
                isOn: viewStore.binding(
                    get: \.isWeeklyNotificationEnabled,
                    send: WeeklyNotificationReducer.Action.isWeeklyNotificationChanged
                )
            )
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}

// MARK: - Previews

struct WeeklyNotificationView_Previews: PreviewProvider {
    
    static var previews: some View {
        let store = Store(initialState: WeeklyNotificationReducer.State()) {
            WeeklyNotificationReducer()
        }
        
        WeeklyNotificationView(store: store)
    }
}
