//
//  RootView.swift
//  LifeProgress
//
//  Created by Bartosz Król on 17/03/2023.
//

import SwiftUI
import ComposableArchitecture

struct RootView: View {
    
    @Environment(\.horizontalSizeClass) var sizeClass
    @Environment(\.theme) var theme
    
    let store: RootStore
    
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
                WithViewStore(self.store) { viewStore in
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
            WithViewStore(self.store) { viewStore in
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
        let store = Store<RootReducer.State, RootReducer.Action>(
            initialState: RootReducer.State(),
            reducer: RootReducer()
        )
        RootView(store: store)
    }
}
