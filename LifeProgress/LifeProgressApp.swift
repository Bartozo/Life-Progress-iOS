//
//  LifeProgressApp.swift
//  LifeProgress
//
//  Created by Bartosz Król on 08/03/2023.
//

import SwiftUI

@main
struct LifeProgressApp: App {
    let coreDataManager = CoreDataManager.shared
    
    let store = RootStore(
        initialState: RootReducer.State(),
        reducer: RootReducer()
    )

    var body: some Scene {
        WindowGroup {
            RootView(store: self.store)
                .modifier(
                    ThemeApplicator(
                        store: self.store.scope(state: \.profile.theme).actionless
                    )
                )
                .environment(\.managedObjectContext, coreDataManager.container.viewContext)
        }
    }
}

