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
    @Environment(\.theme) var theme
    
    let store: StoreOf<RootReducer>
    
    var nonAnimatedTransaction: Transaction {
        var t = Transaction()
        t.disablesAnimations = true
        
        return t
    }
    
    var body: some View {
        if sizeClass == .regular {
            NavigationSplitView {
                WithViewStore(self.store, observe: \.selectedTab) { viewStore in
                    List(
                        RootReducer.State.Tab.allCases,
                        id: \.self,
                        selection: viewStore.binding(
                            get: { $0 },
                            send: RootReducer.Action.tabChanged
                        )
                        .transaction(nonAnimatedTransaction)
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
                    NavigationStack(
                        path: viewStore.binding(
                            get: \.path,
                            send: RootReducer.Action.pathChanged
                        )
                    ) {
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
        } else {
            // Tab View Navigation for iPhone
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                TabView(
                    selection: viewStore.binding(
                        get: \.selectedTabIndex,
                        send: RootReducer.Action.tabIndexChanged
                    )
                ) {
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
}


// MARK: - Previews

struct RootView_Previews: PreviewProvider {
    
    static var previews: some View {
        let store = Store(initialState: RootReducer.State()) {
            RootReducer()
        }
        
        RootView(store: store)
    }
}
