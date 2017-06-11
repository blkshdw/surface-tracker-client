//
//  Acceleration.swift
//  SurfaceTracker
//
//  Created by Алексей on 23.05.17.
//  Copyright © 2017 tetofa. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreMotion

class Acceleration: Mappable {
  var x: Double = 0
  var y: Double = 0
  var z: Double = 0

  init(_ acceleration: CMAcceleration?) {
    x = acceleration?.x ?? 0
    y = acceleration?.y ?? 0
    z = acceleration?.z ?? 0
  }

  required init?(map: Map) { }

  func mapping(map: Map) {
    x <- map["x"]
    y <- map["y"]
    z <- map["z"]
  }

}
