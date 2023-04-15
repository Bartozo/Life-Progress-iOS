//
//  NSUbiquitousKeyValueStore+Extension.swift
//  LifeProgress
//
//  Created by Bartosz Król on 04/04/2023.
//

import Foundation

/// Extension to enhance `NSUbiquitousKeyValueStore` with convenience properties for specific keys.
extension NSUbiquitousKeyValueStore {
    
    /// Property representing the "birthday" key. Returns an optional `NSNumber` or `nil`.
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
    
    /// Property representing the "lifeExpectancy" key. Returns an optional `NSNumber` or `nil`.
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
    
    /// Property representing the "theme" key. Returns an optional `NSString` or `nil`.
    @objc var theme: NSString? {
        get {
            if let value = object(forKey: NSUbiquitousKeyValueStoreHelper.Key.theme.rawValue) as? NSString {
                 return value
             }
             return nil
         }
         set {
             set(newValue, forKey: NSUbiquitousKeyValueStoreHelper.Key.theme.rawValue)
         }
    }
}
