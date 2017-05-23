//
//  Bump.swift
//  AutoYama
//
//  Created by Алексей on 17.05.17.
//  Copyright © 2017 tetofa. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreLocation

class Bump: Mappable {
  var latitude: Double? = nil
  var longitude: Double? = nil
  var location: CLLocationCoordinate2D? {
    get {
      guard let latitude = latitude, let longitude = longitude else { return nil }
      return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    set {
      latitude = newValue?.latitude
      longitude = newValue?.longitude
    }
  }

  var acceleration: Acceleration? = nil

  required init?(map: Map) { }

  init(location: CLLocationCoordinate2D?, acceleration: Acceleration) {
    self.location = location
    self.acceleration = acceleration
  }

  func mapping(map: Map) {
    latitude <- map["latitude"]
    longitude <- map["longitude"]
    acceleration <- map["acceleration"]
  }
}
