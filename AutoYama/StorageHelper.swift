//
//  StorageHelper.swift
//  AutoYama
//
//  Created by Алексей on 22.05.17.
//  Copyright © 2017 tetofa. All rights reserved.
//

import Foundation

class StorageHelper {

  enum StorageError: Error {
    case keychainOnlyStringSupported
  }

  enum StorageKey: String {
    case isLoaded
    case bumps
  }

  static func save(_ object: Any?, forKey key: StorageKey) throws {
    let userDefaults = UserDefaults.standard
    userDefaults.set(object, forKey: key.rawValue)
  }

  static func loadObjectForKey<T>(_ key: StorageKey) -> T? {
    let userDefaults = UserDefaults.standard
    let object = userDefaults.object(forKey: key.rawValue)
    return object as? T
  }
}
