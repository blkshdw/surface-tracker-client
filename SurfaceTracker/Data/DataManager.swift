//
//  DataManager.swift
//  SurfaceTracker
//
//  Created by Алексей on 13.06.17.
//  Copyright © 2017 tetofa. All rights reserved.
//

import Foundation
import PromiseKit
import ObjectMapper

class DataManager {
  static func sendSavedBumps(_ bumps: [Bump]) -> Promise<Void> {
    let bumpsJSON = bumps.toJSON()
    return NetworkManager.doRequest(.sendBumps, ["bumps": bumpsJSON]).then { _ in
      debugPrint("Bumps sent: \(bumpsJSON.count)")
      NotificationManager.show("Bumps sent: \(bumpsJSON.count)")
      return Promise(value: ())
    }
  }

  static func fetchBumps() -> Promise<[Bump]> {
    return NetworkManager.doRequest(.fetchBumps).then { data in
      guard let bumps = Mapper<Bump>().mapArray(JSONObject: data) else { return Promise(error: DataError.unprocessableData) }
      return Promise(value: bumps)
    }
  }
}
