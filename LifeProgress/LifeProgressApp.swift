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
                        store: self.store.scope(
                            state: \.settings.theme,
                            action: { themeAction in
                                return RootReducer.Action.settings(.theme(themeAction))
                            }
                        )
                    )
                )
                .environment(\.managedObjectContext, coreDataManager.container.viewContext)
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

