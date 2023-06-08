//
//  RootView+WhatsNewCollectionProvider.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 27/05/2023.
//

import Foundation
import WhatsNewKit

// MARK: - LifeProgressApp+WhatsNewCollectionProvider

extension RootView: WhatsNewCollectionProvider {
    
    /// Provides the collection of "What's New" information for the LifeProgressApp.
    var whatsNewCollection: WhatsNewCollection {
        WhatsNew(
            version: "1.0.1",
            title: "What's New in Life Progress",
            features: [
                .init(
                    image: .init(
                        systemName: "arrow.clockwise",
                        foregroundColor: theme.color
                    ),
                    title: "Updates from the app",
                    subtitle: "Stay informed about new versions"
                ),
                .init(
                    image: .init(
                        systemName: "sparkles",
                        foregroundColor: theme.color
                    ),
                    title: "Discover new features",
                    subtitle: "Stay up-to-date with cool additions"
                ),
                .init(
                    image: .init(
                        systemName: "wrench",
                        foregroundColor: theme.color
                    ),
                    title: "Bug fixes",
                    subtitle: "Improving stability and reliability"
                ),
            ],
            primaryAction: .init(
                backgroundColor: theme.color
            )
        )
    }
}
