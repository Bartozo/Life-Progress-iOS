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
                store: store.scope(
                    state: \.iap,
                    action: \.iap
                )
            )
            
            Section {
                BirthdayView(
                    store: store.scope(
                        state: \.birthday,
                        action: \.birthday
                    )
                )
                LifeExpectancyView(
                    store: store.scope(
                        state: \.lifeExpectancy,
                        action: \.lifeExpectancy
                    )
                )
            } header: {
                Text("User")
            }
            
            Section {
                WeeklyNotificationView(
                    store: store.scope(
                        state: \.weeklyNotification,
                        action: \.weeklyNotification
                    )
                )
            } header: {
                Text("Notifications")
            } footer: {
                Text("Receive a weekly notification with your current life progress.")
            }
            
            Section {
                ThemeView(
                    store: store.scope(
                        state: \.theme,
                        action: \.theme
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
                        store: store.scope(
                            state: \.credits,
                            action: \.credits
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
                        store: store.scope(
                            state: \.developer,
                            action: \.developer
                        )
                    )
                    .padding()
                    Spacer()
                }
            }
        }
        .navigationTitle("Settings")
    }
    
    private func rateApp() {
        guard let url = URL(string: "https://apps.apple.com/us/app/life-progress-calendar/id6447311106?action=write-review") else { return }
        
        UIApplication.shared.open(url)
    }
    
    private func contactDeveloper() {
        guard let email = URL(string: "mailto:bartozo.dev@gmail.com")  else { return }
        
        UIApplication.shared.open(email)
    }
}


// MARK: - Previews

#Preview {
    NavigationStack {
        SettingsView(
            store: Store(initialState: SettingsReducer.State()) {
                SettingsReducer()
            }
        )
    }
}
