//
//  RootView.swift
//  LifeProgress
//
//  Created by Bartosz Król on 17/03/2023.
//

import SwiftUI
import ComposableArchitecture

struct RootView: View {
    
    let store: RootStore
    
    var body: some View {
        NavigationView {
            ProfileView(
                store: store.scope(
                    state: \.profile,
                    action: RootReducer.Action.profile
                )
            )
        }
        .modifier(
            ThemeApplicator(
                store: store.scope(
                    state: \.theme,
                    action: RootReducer.Action.theme
                )
            )
        )
    }
}

//struct RootView_Previews: PreviewProvider {
//    static var previews: some View {
//        RootView()
//    }
//}
