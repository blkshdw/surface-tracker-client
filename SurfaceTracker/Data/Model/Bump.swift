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

class Bump: Mappable {
  var id = UUID().uuidString
  var location: LocationCoordinate? = nil
  var acceleration: Acceleration? = nil
  var hasPotholes: Bool = false

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
  }
}
