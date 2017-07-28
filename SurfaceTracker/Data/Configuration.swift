//
//  Configuration.swift
//  SurfaceTracker
//
//  Created by Алексей on 12.06.17.
//  Copyright © 2017 tetofa. All rights reserved.
//

import Foundation
import ObjectMapper

class Configuration: Mappable {
  var pushNotificationEnabled: Bool = true
  var debugMode: Bool = true
  var debugNotifications: Bool = true
  var useLocationInBaground: Bool = true

  static var current: Configuration {
    guard let configurationJSON: String = StorageHelper.loadObjectForKey(.configuration) else {
      return Configuration()
    }
    return Mapper<Configuration>().map(JSONString: configurationJSON) ?? Configuration()
  }

  func save() {
    StorageHelper.save(self.toJSONString(), forKey: .configuration)
    if debugMode {
      BumpManager.instance.startMonitoring()
    } else {
      BumpManager.instance.stopMonitoring()
    }
  }

  required init?(map: Map) {

  }

  private init() {

  }

  func mapping(map: Map) {
    pushNotificationEnabled <- map["pushNotificationEnabled"]
    debugMode <- map["debugMode"]
  }

}
