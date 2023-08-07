//
//  PackageCredit.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 01/08/2023.
//

import Foundation

/// A structure representing a used package in the app.
struct PackageCredit: Hashable, Identifiable {
    /// The title of package.
    let title: String
    
    /// The URL where the package is hosted or where more information can be found.
    let url: String

    /// A unique identifier for the package credit instance.
    let id = UUID()
    
    /// Initializes an `PackageCredit` instance with the provided title and url.
    ///
    /// - Parameters:
    ///   - title: The title of package.
    ///   - url: The URL of the package, where more information can be found.
    init(title: String, url: String) {
        self.title = title
        self.url = url
    }
    
    /// Retrieves a list of `PackageCredit` instances representing the used dependencies in the app.
    ///
    /// - Returns: An array of `PackageCredit` instances.
    static func getPackageCredits() -> [PackageCredit] {
        return [
            PackageCredit(
                title: "swift-composable-architecture",
                url: "https://github.com/pointfreeco/swift-composable-architecture"
            ),
            PackageCredit(
                title: "TelemetryClient",
                url: "https://github.com/TelemetryDeck/SwiftClient"
            ),
            PackageCredit(
                title: "SymbolPicker",
                url: "https://github.com/xnth97/SymbolPicker"
            ),
            PackageCredit(
                title: "ConfettiSwiftUI",
                url: "https://github.com/simibac/ConfettiSwiftUI"
            ),
            PackageCredit(
                title: "WhatsNewKit",
                url: "https://github.com/SvenTiigi/WhatsNewKit"
            ),
            PackageCredit(
                title: "Siren",
                url: "https://github.com/ArtSabintsev/Siren"
            )
        ]
    }
}
