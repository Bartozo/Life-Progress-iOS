//
//  AnalyticsClient.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 05/05/2023.
//

import Foundation
import Dependencies
import TelemetryClient

/// The `AnalyticsClient` is a struct that provides a set of closures for ...
struct AnalyticsClient {
    // A closure that initializes the analytics.
    var initialize: () -> Void
    
    // A closure that sends a new event to the analytics.
    var send: (String) -> Void
    
    // A closure that sends a new event with payload to the analytics.
    var sendWithPayload: (String, [String : String]) -> Void
}

// MARK: Dependency Key

extension AnalyticsClient: DependencyKey {
    
    static let liveValue = Self(
        initialize: {
            let configuration = TelemetryManagerConfiguration(appID: UUID().uuidString)
            TelemetryManager.initialize(with: configuration)
        },
        send: { event in
            TelemetryManager.send(event)
        },
        sendWithPayload: { event, payload in
            TelemetryManager.send(event, with: payload)
        }
    )
}


// MARK: Test Dependency Key

extension AnalyticsClient: TestDependencyKey {

    /// A preview instance of `AnalyticsClient` with mock data for SwiftUI previews and testing purposes.
    static let previewValue = Self(
        initialize: { },
        send: { _ in },
        sendWithPayload: { _, _ in }
    )

    /// A test instance of `AnalyticsClient` with mock data for unit testing purposes.
    static let testValue = Self(
        initialize: { },
        send: { _ in },
        sendWithPayload: { _, _ in }
    )
}

// MARK: Dependency Values

extension DependencyValues {
    
    /// A property wrapper for accessing and updating the `AnalyticsClient` instance within the dependency container.
    var analyticsClient: AnalyticsClient {
        get { self[AnalyticsClient.self] }
        set { self[AnalyticsClient.self] = newValue }
    }
}
