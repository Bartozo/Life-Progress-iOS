//
//  CreditsStore.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 01/08/2023.
//

import Foundation
import ComposableArchitecture

/// A reducer that manages the state of the credits.
@Reducer
struct CreditsReducer {
    
    /// The state of the credits.
    @ObservableState
    struct State: Equatable {
        /// List of used packages in the app.
        var packageCredits: [PackageCredit] = PackageCredit.getPackageCredits()
    }
    
    /// The actions that can be taken on the credits.
    enum Action: Equatable {
        /// Indicates that the `PackageCredit` item has been tapped.
        case packageCreditTapped(PackageCredit)
    }
    
    @Dependency(\.openURL) var openURL
    
    /// The body of the reducer that processes incoming actions and updates the state accordingly.
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .packageCreditTapped(let packageCredit):
                guard let url = URL(string: packageCredit.url) else {
                    return .none
                }
                
                return .run { _ in 
                    await openURL(url)
                }
            }
        }
    }
}
