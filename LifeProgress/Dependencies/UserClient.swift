//
//  UserDefaultsHelper.swift
//  LifeProgress
//
//  Created by Bartosz Król on 19/03/2023.
//

import Foundation
import Dependencies

struct UserClient {
    var getLife: () -> Life
    var getBirthday: () -> Date
    var getLifeExpectancy: () -> Int
}

// MARK: Dependency Key
extension UserClient: DependencyKey {
    
    static let liveValue = Self(
        getLife: { return Life(birthday: Date.now, lifeExpectancy: 90) },
        getBirthday: { return Date.now },
        getLifeExpectancy: { return 90 }
    )
}

// MARK: Test Dependency Key
extension UserClient: TestDependencyKey {
    
    static let previewValue = Self(
        getLife: { .mock },
        getBirthday: { Life.mock.birthday },
        getLifeExpectancy: { Life.mock.lifeExpectancy }
    )
    
    static let testValue = Self(
        getLife: { .mock },
        getBirthday: { Life.mock.birthday },
        getLifeExpectancy: { Life.mock.lifeExpectancy }
    )
}

extension DependencyValues {
    
    var userClient: UserClient {
        get { self[UserClient.self] }
        set { self[UserClient.self] = newValue }
    }
}
