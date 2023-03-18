//
//  LifeProgressApp.swift
//  LifeProgress
//
//  Created by Bartosz Król on 08/03/2023.
//

import SwiftUI

@main
struct LifeProgressApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            RootView(
                store: RootStore(
                    initialState: RootReducer.State(),
                    reducer: RootReducer()
                )
            )
//            HomeView(
//                store: HomeStore(
//                    initialState: HomeReducer.State(),
//                    reducer: HomeReducer()
//                )
//            )
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
