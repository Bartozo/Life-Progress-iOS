//
//  SettingsView.swift
//  LifeProgress
//
//  Created by Bartosz Król on 13/03/2023.
//

import SwiftUI
import ComposableArchitecture

struct SettingsView: View {
    
    @Environment(\.theme) var theme
    
    let store: StoreOf<SettingsReducer>
    
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
                ShareLink(item: URL(string: "https://apps.apple.com/us/app/life-progress-calendar/id6447311106")!) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                            .frame(maxWidth: 30)
                            .padding(.trailing, 10)
                            .foregroundColor(theme.color)
                        
                        Text("Share the app")
                        
                        Spacer()
                        NavigationLink.empty
                            .frame(maxWidth: 30)
                    }
                }
                .tint(.primary)
                
                SettingsCell(title: "Rate the app", systemImage: "star") {
                    rateApp()
                }
                SettingsCell(title: "Contact developer", systemImage: "envelope") {
                    contactDeveloper()
                }
                NavigationLink {
                    CreditsView(
                        store: self.store.scope(
                            state: \.credits,
                            action: SettingsReducer.Action.credits
                        )
                    )
                } label: {
                    Image(systemName: "shippingbox")
                        .frame(maxWidth: 30)
                        .padding(.trailing, 10)
                        .foregroundColor(theme.color)
                    
                    Text("Credits")
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
    
    func rateApp() {
        guard let url = URL(string: "https://apps.apple.com/us/app/life-progress-calendar/id6447311106?action=write-review") else { return }
        
        UIApplication.shared.open(url)
    }
    
    func contactDeveloper() {
        guard let email = URL(string: "mailto:bartozo.dev@gmail.com")  else { return }
        
        UIApplication.shared.open(email)
    }
}


// MARK: - Previews

struct ProfileView_Previews: PreviewProvider {
    
    static var previews: some View {
        let store = Store(initialState: SettingsReducer.State()) {
            SettingsReducer()
        }
        
        NavigationStack {
            SettingsView(store: store)
        }
    }
}
