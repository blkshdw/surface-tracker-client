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
  var amplitude: Double = 0

  init(_ acceleration: CMAcceleration?) {
    x = acceleration?.x ?? 0
    y = acceleration?.y ?? 0
    z = acceleration?.z ?? 0

    self.amplitude = sqrt(x ^^ 2 + y ^^ 2 + z ^^ 2)
  }

  required init?(map: Map) { }

  func mapping(map: Map) {
    x <- map["x"]
    y <- map["y"]
    z <- map["z"]
    amplitude <- map["amplitude"]
  }

}

extension Acceleration {
  static func average(_ first: Acceleration, _ second: Acceleration) -> Acceleration {
    let averageX = (first.x + second.x)/2
    let averageY = (first.y + second.y)/2
    let averageZ = (first.z + second.z)/2
    let cmAcceleration = CMAcceleration(x: averageX, y: averageY, z: averageZ)
    return Acceleration(cmAcceleration)
  }
}

extension CMAcceleration {
  static func average(_ first: CMAcceleration, _ second: CMAcceleration) -> CMAcceleration {
    let averageX = (first.x + second.x)/2
    let averageY = (first.y + second.y)/2
    let averageZ = (first.z + second.z)/2
    return CMAcceleration(x: averageX, y: averageY, z: averageZ)
  }
}

precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }
infix operator ^^ : PowerPrecedence

func ^^ (radix: Double, power: Int) -> Double {
  return (pow(Double(radix), Double(power)))
}
