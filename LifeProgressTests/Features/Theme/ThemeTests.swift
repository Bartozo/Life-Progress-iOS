//
//  ThemeTests.swift
//  LifeProgressTests
//
//  Created by Bartosz Król on 18/07/2023.
//

import XCTest
import ComposableArchitecture

@testable import Life_Progress___Calendar

@MainActor
class ThemeTests: XCTestCase {
    
    func testThemeChanged_ShouldUpdateTheme() async {
        let store = TestStore(initialState: ThemeReducer.State()) {
            ThemeReducer()
        }
        
        await store.send(.themeChanged(.orange)) {
            $0.selectedTheme = .orange
        }
    }
    
    func testChangeThemeTapped_ShouldSaveAndUpdatetheme() async {
        var updatedTheme = Theme.blue
        let store = TestStore(initialState: ThemeReducer.State()) {
            ThemeReducer()
        } withDependencies: {
            $0.userSettingsClient.updateTheme = { @MainActor theme in
                updatedTheme = theme
            }
        }
        
        await store.send(.set(\.selectedTheme, Theme.red)) {
            $0.selectedTheme = Theme.red
        }
        
        await store.receive(.themeChanged(.red))
        
        XCTAssertEqual(updatedTheme, Theme.red)
    }
    
    func testChangeThemeTapped_ShouldAddToAnalytics() async {
        var eventName = ""
        var eventPayload = [String: String]()
        var updatedTheme = Theme.blue
        let store = TestStore(initialState: ThemeReducer.State()) {
            ThemeReducer()
        } withDependencies: {
            $0.analyticsClient.sendWithPayload = { event, payload in
                eventName = event
                eventPayload = payload
            }
            $0.userSettingsClient.updateTheme = { @MainActor theme in
                updatedTheme = theme
            }
        }
        store.exhaustivity = .off

        await store.send(.set(\.selectedTheme, Theme.orange))
        await store.send(.themeChanged(.orange))

        XCTAssertEqual(eventName, "theme.change_theme_tapped")
        XCTAssertEqual(eventPayload, ["selectedTheme": "\(updatedTheme)"])
    }
}
