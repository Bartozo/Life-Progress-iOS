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
            version: "1.1.0",
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
                        systemName: "wrench",
                        foregroundColor: theme.color
                    ),
                    title: "Bug fixes",
                    subtitle: "Improving stability and reliability"
                ),
                .init(
                    image: .init(
                        systemName: "square.and.arrow.up",
                        foregroundColor: theme.color
                    ),
                    title: "Share Life Goal",
                    subtitle: "Share completed life goals as images with friends"
                ),
                .init(
                    image: .init(
                        systemName: "gear",
                        foregroundColor: theme.color
                    ),
                    title: "Added Credits to Settings",
                    subtitle: "View packages used in the project"
                ),
            ],
            primaryAction: .init(
                backgroundColor: theme.color
            )
        )
        WhatsNew(
            version: "1.1.1",
            title: "What's New in Life Progress",
            features: [
                .init(
                    image: .init(
                        systemName: "wrench.adjustable",
                        foregroundColor: theme.color
                    ),
                    title: "Bug Fixes",
                    subtitle: "Fixed issues and improved app stability for a smoother experience"
                ),
            ],
            primaryAction: .init(
                backgroundColor: theme.color
            )
        )
    }
}
