//
//  ProfileView.swift
//  LifeProgress
//
//  Created by Bartosz Król on 13/03/2023.
//

import SwiftUI
import ComposableArchitecture

struct ProfileView: View {
    
    let store: ProfileStore
    
    var body: some View {
            Form {
                Section {
                    BirthdayView(
                        store: self.store.scope(
                            state: \.birthday,
                            action: ProfileReducer.Action.birthday
                        )
                    )
                    LifeExpectancyView(
                        store: self.store.scope(
                            state: \.lifeExpectancy,
                            action: ProfileReducer.Action.lifeExpectancy
                        )
                    )
                } header: {
                    Text("User")
                }
                
                Section {
                    WeeklyNotificationView(
                        store: self.store.scope(
                            state: \.weeklyNotification,
                            action: ProfileReducer.Action.weeklyNotification
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
                            action: ProfileReducer.Action.theme
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
        let store = Store<ProfileReducer.State, ProfileReducer.Action>(
            initialState: ProfileReducer.State(),
            reducer: ProfileReducer()
        )
        ProfileView(store: store)
    }
}
