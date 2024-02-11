//
//  LifeProgressApp.swift
//  LifeProgress
//
//  Created by Bartosz Król on 08/03/2023.
//

import SwiftUI
import BackgroundTasks
import ComposableArchitecture
import TelemetryClient
import Siren
import WhatsNewKit

@main
struct LifeProgressApp: App {
    
    @Environment(\.scenePhase) private var phase
    
    @Dependency(\.notificationsClient) var notificationsClient
    @Dependency(\.userSettingsClient) var userSettingsClient
    @Dependency(\.analyticsClient) var analyticsClient
    
    let store: StoreOf<RootReducer>
    
    let coreDataManager: CoreDataManager
    
    init() {
        self.store = Store(initialState: RootReducer.State()) {
            RootReducer()
        }
        self.coreDataManager = CoreDataManager.shared
        
        analyticsClient.initialize()
    }

    var body: some Scene {
        WindowGroup {
            RootView(store: self.store)
                .modifier(
                    ThemeApplicator(
                        store: store.scope(
                            state: \.settings.theme,
                            action: \.settings.theme
                        )
                    )
                )
                .environment(\.managedObjectContext, coreDataManager.container.viewContext)
                .environment(\.whatsNew, WhatsNewEnvironment(whatsNewCollection: self))
                .task {
                    Siren.shared.wail()
                }
        }
        .backgroundTask(.appRefresh("com.bartozo.LifeProgress.weekly-notification")) {
            notificationsClient.updateDidScheduleWeeklyNotification(false)
            
            // Show the weekly notification only if this feature was enabled
            guard !userSettingsClient.getIsWeeklyNotificationEnabled() else {
                return scheduleBackgroundTask()
            }
            
            let content = notificationsClient.getWeeklyNotification()
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            do {
                try await UNUserNotificationCenter.current().add(request)
            } catch {
                print("❌ Could not show the notification: \(error)")
            }
              
            // Reschedule the background task for next week
            scheduleBackgroundTask()
        }
        .onChange(of: phase) { oldPhase, newPhase in
             switch newPhase {
             case .background: scheduleBackgroundTask()
             default: break
             }
         }
    }
    
    // Schedule the background task
    private func scheduleBackgroundTask() {
        // Scheduling the same background task will override the previous one
        guard !notificationsClient.getDidScheduleWeeklyNotification() else {
            return
        }
        
        let request = BGAppRefreshTaskRequest(identifier: "com.bartozo.LifeProgress.weekly-notification")
        request.earliestBeginDate = .now.addingTimeInterval(60 * 60 * 24 * 7)
        
        do {
            try BGTaskScheduler.shared.submit(request)
            notificationsClient.updateDidScheduleWeeklyNotification(true)
        } catch {
            print("❌ Could not schedule the background task: \(error)")
            notificationsClient.updateDidScheduleWeeklyNotification(false)
        }
    }
}

// MARK: - LifeProgressApp+WhatsNewCollectionProvider

extension LifeProgressApp: WhatsNewCollectionProvider {
    
    /// Provides the collection of "What's New" information for the LifeProgressApp.
    var whatsNewCollection: WhatsNewCollection {
        WhatsNew(
            version: "1.1.0",
            title: "What's New in Life Progress",
            features: [
                .init(
                    image: .init(
                        systemName: "arrow.clockwise",
                        foregroundColor: store.settings.theme.selectedTheme.color
                    ),
                    title: "Updates from the app",
                    subtitle: "Stay informed about new versions"
                ),
                .init(
                    image: .init(
                        systemName: "wrench",
                        foregroundColor: store.settings.theme.selectedTheme.color
                    ),
                    title: "Bug fixes",
                    subtitle: "Improving stability and reliability"
                ),
                .init(
                    image: .init(
                        systemName: "square.and.arrow.up",
                        foregroundColor: store.settings.theme.selectedTheme.color
                    ),
                    title: "Share Life Goal",
                    subtitle: "Share completed life goals as images with friends"
                ),
                .init(
                    image: .init(
                        systemName: "gear",
                        foregroundColor: store.settings.theme.selectedTheme.color
                    ),
                    title: "Added Credits to Settings",
                    subtitle: "View packages used in the project"
                ),
            ],
            primaryAction: .init(
                backgroundColor: store.settings.theme.selectedTheme.color
            )
        )
        WhatsNew(
            version: "1.1.1",
            title: "What's New in Life Progress",
            features: [
                .init(
                    image: .init(
                        systemName: "wrench.adjustable",
                        foregroundColor: store.settings.theme.selectedTheme.color
                    ),
                    title: "Bug Fixes",
                    subtitle: "Fixed issues and improved app stability for a smoother experience"
                ),
            ],
            primaryAction: .init(
                backgroundColor: store.settings.theme.selectedTheme.color
            )
        )
        WhatsNew(
            version: "1.1.4",
            title: "What's New in Life Progress",
            features: [
                .init(
                    image: .init(
                        systemName: "paintbrush",
                        foregroundColor: store.settings.theme.selectedTheme.color
                    ),
                    title: "UI improvements",
                    subtitle: "Enhanced user interface for a better experience"
                ),
                .init(
                    image: .init(
                        systemName: "wrench",
                        foregroundColor: store.settings.theme.selectedTheme.color
                    ),
                    title: "Bug fixes",
                    subtitle: "Improving stability and reliability"
                ),
            ],
            primaryAction: .init(
                backgroundColor: store.settings.theme.selectedTheme.color
            )
        )
        WhatsNew(
            version: "1.1.5",
            title: "What's New in Life Progress",
            features: [
                .init(
                    image: .init(
                        systemName: "wrench",
                        foregroundColor: store.settings.theme.selectedTheme.color
                    ),
                    title: "Bug fixes",
                    subtitle: "Improving stability and reliability"
                ),
            ],
            primaryAction: .init(
                backgroundColor: store.settings.theme.selectedTheme.color
            )
        )
    }
}

