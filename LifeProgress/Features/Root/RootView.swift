//
//  RootView.swift
//  LifeProgress
//
//  Created by Bartosz Król on 17/03/2023.
//

import SwiftUI
import ComposableArchitecture
import WhatsNewKit

struct RootView: View {
    @Environment(\.theme) var theme
    
    let store: StoreOf<RootReducer>
    
    var body: some View {
        if store.didCompleteOnboarding {
            ContentView(store: store)
                .whatsNewSheet()
        } else {
            OnboardingView(
                store: store.scope(
                    state: \.onboarding,
                    action: \.onboarding
                )
            )
        }
    }
}

private struct ContentView: View {
    @Environment(\.horizontalSizeClass) var sizeClass
    
    let store: StoreOf<RootReducer>
    
    var body: some View {
        if sizeClass == .regular {
            RootSplitView(store: store)
        } else {
            // Tab View Navigation for iPhone
            RootTabView(store: store)
        }
    }
}

private struct RootSplitView: View {
    @Environment(\.theme) var theme
    
    @Bindable var store: StoreOf<RootReducer>
    
    var nonAnimatedTransaction: Transaction {
        var t = Transaction()
        t.disablesAnimations = true
        
        return t
    }
    
    var body: some View {
        NavigationSplitView {
            List(
                RootReducer.State.Tab.allCases,
                id: \.self,
                selection: $store.selectedTab.transaction(nonAnimatedTransaction)
            ) { tab in
                Label {
                    Text(tab.title)
                } icon: {
                    Image(systemName: tab.systemImage)
                }
                .labelStyle(.titleAndIcon)
            }
            .navigationTitle("Life Progress")
        } detail: {
            NavigationStack(path: $store.path) {
                if let selectedTab = store.selectedTab {
                    switch selectedTab {
                    case .lifeCalendar:
                        LifeCalendarView(
                            store: store.scope(
                                state: \.lifeCalendar,
                                action: \.lifeCalendar
                            )
                        )
                        
                    case .lifeGoals:
                        LifeGoalsView(
                            store: store.scope(
                                state: \.lifeGoals,
                                action: \.lifeGoals
                            )
                        )
                        
                    case .settings:
                        SettingsView(
                            store: store.scope(
                                state: \.settings,
                                action: \.settings
                            )
                        )
                    }
                } else {
                    Text("")
                }
            }
        }
        .accentColor(theme.color)
    }
}

private struct RootTabView: View {
    @Environment(\.theme) var theme
    
    @Bindable var store: StoreOf<RootReducer>
    
    var body: some View {
        TabView(selection: $store.selectedTabIndex) {
            ForEach(RootReducer.State.Tab.allCases) { tab in
                NavigationStack {
                    switch tab {
                    case .lifeCalendar:
                        LifeCalendarView(
                            store: store.scope(
                                state: \.lifeCalendar,
                                action: \.lifeCalendar
                            )
                        )
                        
                    case .lifeGoals:
                        LifeGoalsView(
                            store: store.scope(
                                state: \.lifeGoals,
                                action: \.lifeGoals
                            )
                        )
                        
                    case .settings:
                        SettingsView(
                            store: store.scope(
                                state: \.settings,
                                action: \.settings
                            )
                        )
                    }
                }
                .tabItem {
                    Label(tab.title, systemImage: tab.systemImage)
                }
            }
        }
        .accentColor(theme.color)
    }
}

// MARK: - Previews

#Preview {
    RootView(
        store: Store(initialState: RootReducer.State()) {
            RootReducer()
        }
    )
}
