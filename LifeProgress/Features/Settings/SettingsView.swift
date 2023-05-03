//
//  SettingsView.swift
//  LifeProgress
//
//  Created by Bartosz Król on 13/03/2023.
//

import SwiftUI
import ComposableArchitecture

struct SettingsView: View {
    
    let store: SettingsStore
    
    var body: some View {
        Form {
            PremiumCell(
                store: self.store.scope(
                    state: \.iap,
                    action: SettingsReducer.Action.iap
                )
            )
            
            Section {
                BirthdayView(
                    store: self.store.scope(
                        state: \.birthday,
                        action: SettingsReducer.Action.birthday
                    )
                )
                LifeExpectancyView(
                    store: self.store.scope(
                        state: \.lifeExpectancy,
                        action: SettingsReducer.Action.lifeExpectancy
                    )
                )
            } header: {
                Text("User")
            }
            
            Section {
                WeeklyNotificationView(
                    store: self.store.scope(
                        state: \.weeklyNotification,
                        action: SettingsReducer.Action.weeklyNotification
                    )
                )
            } header: {
                Text("Notifications")
            } footer: {
                Text("Receive a weekly notification with your current life progress.")
            }
            
            Section {
                ThemeView(
                    store: self.store.scope(
                        state: \.theme,
                        action: SettingsReducer.Action.theme
                    )
                )
            } header: {
                Text("Theme")
            }
        }
        .navigationTitle("Profile")
    }
}


// MARK: - Previews

struct ProfileView_Previews: PreviewProvider {
    
    static var previews: some View {
        let store = Store<SettingsReducer.State, SettingsReducer.Action>(
            initialState: SettingsReducer.State(
                iap: .init()
            ),
            reducer: SettingsReducer()
        )
        SettingsView(store: store)
    }
}
