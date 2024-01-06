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
        WithViewStore(self.store, observe: \.didCompleteOnboarding) { viewStore in
            if viewStore.state {
                ContentView(store: self.store)
                    .whatsNewSheet()
            } else {
                OnboardingView(
                    store: self.store.scope(
                        state: \.onboarding,
                        action: RootReducer.Action.onboarding
                    )
                )
            }
        }
        .environment(\.whatsNew, WhatsNewEnvironment(whatsNewCollection: self))
    }
}

private struct ContentView: View {
    
    @Environment(\.horizontalSizeClass) var sizeClass
    
    let store: StoreOf<RootReducer>
    
    var body: some View {
        if sizeClass == .regular {
            RootSplitView(store: self.store)
        } else {
            // Tab View Navigation for iPhone
            RootTabView(store: self.store)
        }
    }
}

private struct RootSplitView: View {
    
    @Environment(\.theme) var theme
    
    let store: StoreOf<RootReducer>
    
    var nonAnimatedTransaction: Transaction {
        var t = Transaction()
        t.disablesAnimations = true
        
        return t
    }
    
    var body: some View {
        NavigationSplitView {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                List(
                    RootReducer.State.Tab.allCases,
                    id: \.self,
                    selection: viewStore.$selectedTab.transaction(nonAnimatedTransaction)
                ) { tab in
                    Label {
                        Text(tab.title)
                    } icon: {
                        Image(systemName: tab.systemImage)
                    }
                    .labelStyle(.titleAndIcon)
                }
                .navigationTitle("Life Progress")
            }
        } detail: {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                NavigationStack(path: viewStore.$path) {
                    if let selectedTab = viewStore.selectedTab {
                        switch selectedTab {
                        case .lifeCalendar:
                            LifeCalendarView(
                                store: store.scope(
                                    state: \.lifeCalendar,
                                    action: RootReducer.Action.lifeCalendar
                                )
                            )
                            
                        case .lifeGoals:
                            LifeGoalsView(
                                store: store.scope(
                                    state: \.lifeGoals,
                                    action: RootReducer.Action.lifeGoals
                                )
                            )
                            
                        case .settings:
                            SettingsView(
                                store: store.scope(
                                    state: \.settings,
                                    action: RootReducer.Action.settings
                                )
                            )
                        }
                    } else {
                        Text("")
                    }
                }
            }
        }
        .accentColor(theme.color)
    }
}

private struct RootTabView: View {
    
    @Environment(\.theme) var theme
    
    let store: StoreOf<RootReducer>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            TabView(selection: viewStore.$selectedTabIndex) {
                ForEach(RootReducer.State.Tab.allCases) { tab in
                    NavigationStack {
                        switch tab {
                        case .lifeCalendar:
                            LifeCalendarView(
                                store: store.scope(
                                    state: \.lifeCalendar,
                                    action: RootReducer.Action.lifeCalendar
                                )
                            )
                            
                        case .lifeGoals:
                            LifeGoalsView(
                                store: store.scope(
                                    state: \.lifeGoals,
                                    action: RootReducer.Action.lifeGoals
                                )
                            )
                            
                        case .settings:
                            SettingsView(
                                store: store.scope(
                                    state: \.settings,
                                    action: RootReducer.Action.settings
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
}

// MARK: - Previews

#Preview {
    let store = Store(initialState: RootReducer.State()) {
        RootReducer()
    }
    
    return RootView(store: store)
}
