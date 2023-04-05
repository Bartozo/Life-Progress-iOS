//
//  NSUbiquitousKeyValueStore+Extension.swift
//  LifeProgress
//
//  Created by Bartosz Król on 04/04/2023.
//

import Foundation

extension NSUbiquitousKeyValueStore {
    @objc var birthday: NSNumber? {
        get {
            if let value = object(forKey: NSUbiquitousKeyValueStoreHelper.Key.birthday.rawValue) as? NSNumber {
                 return value
             }
             return nil
         }
         set {
             set(newValue, forKey: NSUbiquitousKeyValueStoreHelper.Key.birthday.rawValue)
         }
    }
    
    @objc var lifeExpectancy: NSNumber? {
        get {
            if let value = object(forKey: NSUbiquitousKeyValueStoreHelper.Key.lifeExpectancy.rawValue) as? NSNumber {
                 return value
             }
             return nil
         }
         set {
             set(newValue, forKey: NSUbiquitousKeyValueStoreHelper.Key.lifeExpectancy.rawValue)
         }
    }
}
