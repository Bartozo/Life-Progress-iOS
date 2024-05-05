//
//  PersistenceReaderKey+Extension.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 05/05/2024.
//

import ComposableArchitecture

extension PersistenceReaderKey where Self == PersistenceKeyDefault<AppStorageKey<Bool>> {
    
    /// Whether the onboarding flow was completed.
    static var didCompleteOnboarding: Self {
        PersistenceKeyDefault(.appStorage("DidCompleteOnboarding"), false)
    }
    
    /// Whether the weekly notification was scheduled.
    static var didScheduleWeeklyNotification: Self {
        PersistenceKeyDefault(.appStorage("DidScheduleWeeklyNotification"), false)
    }
}
