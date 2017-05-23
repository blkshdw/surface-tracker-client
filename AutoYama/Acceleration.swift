//
//  Acceleration.swift
//  AutoYama
//
//  Created by Алексей on 23.05.17.
//  Copyright © 2017 tetofa. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreMotion

class Acceleration: Mappable {
  var x: Double!
  var y: Double!
  var z: Double!

  init(acceleration: CMAcceleration) {
    x = acceleration.x
    y = acceleration.y
    z = acceleration.z
  }

  required init?(map: Map) { }

  func mapping(map: Map) {
    x <- map["x"]
    y <- map["y"]
    z <- map["z"]
  }

}
