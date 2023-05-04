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
            
            Section {
                SettingsCell(title: "Share the app", systemImage: "square.and.arrow.up") {
                    ShareLink("Check out this cool app!", item: URL(string: "https://www.google.com")!)
                }
                SettingsCell(title: "Rate the app", systemImage: "star") {
                    
                }
                SettingsCell(title: "Contact developer", systemImage: "envelope") {
                    
                }
            } header: {
                Text("Feedback")
            } footer: {
                HStack {
                    Spacer()
                    DeveloperView(
                        store: self.store.scope(
                            state: \.developer,
                            action: SettingsReducer.Action.developer
                        )
                    )
                    .padding()
                    Spacer()
                }
            }
        }
        .navigationTitle("Settings")
    }
    
    private func shareApp() {
        let items = ["Check out this cool app!"]
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
    
    func rateApp() {
        guard let url = URL(string: "https://itunes.apple.com/app/idYOUR_APP_ID_HERE") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func contactDeveloper() {
        guard let email = URL(string: "mailto:youremail@example.com") else { return }
        UIApplication.shared.open(email)
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
        NavigationStack {
            SettingsView(store: store)
        }
    }
}
