//
//  Bump.swift
//  SurfaceTracker
//
//  Created by Алексей on 17.05.17.
//  Copyright © 2017 tetofa. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreLocation
import CoreMotion
import UIKit

class Bump: Mappable {
  var id = UUID().uuidString
  var location: LocationCoordinate? = nil
  var acceleration: Acceleration? = nil
  var date: Date = Date()
  var hasPotholes: Bool = false

  var bumpType: BumpType? {
    guard let amplitude = acceleration?.amplitude else { return nil }
    if amplitude > BumpType.danger.rawValue {
      return .danger
    } else if amplitude > BumpType.alert.rawValue {
      return .alert
    } else if amplitude > BumpType.light.rawValue {
      return .light
    }
    return nil
  }

  required init?(map: Map) { }

  init(location: CLLocationCoordinate2D?, acceleration: CMAcceleration?) {
    self.location = LocationCoordinate(location: location)
    self.acceleration = Acceleration(acceleration)
  }

  func mapping(map: Map) {
    id <- map["id"]
    location <- map["location"]
    acceleration <- map["acceleration"]
    hasPotholes <- map["hasPotHoles"]
    date <- (map["date"], DateTransform())
  }
}

enum BumpType: Double {
  case danger = 1.6
  case alert = 1.36
  case light = 1.25

  var color: UIColor {
    switch self {
    case .danger:
      return UIColor.red.withAlphaComponent(0.8)
    case .alert:
      return UIColor.orange.withAlphaComponent(0.8)
    case .light:
      return UIColor.yellow.withAlphaComponent(0.8)
    }
  }
}
