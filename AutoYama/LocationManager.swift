//
//  LocationManager.swift
//  AutoYama
//
//  Created by Алексей on 11.04.17.
//  Copyright © 2017 tetofa. All rights reserved.
//

import Foundation
import CoreLocation
import CoreMotion

class LocationManager: NSObject {
  static let instance = LocationManager()

  let motionManager = CMMotionManager()
  let locationManager = CLLocationManager()

  var currentLocation: CLLocation? = nil

  private override init() {
    super.init()
    motionManager.accelerometerUpdateInterval = 0.5
    locationManager.delegate = self
  }

  func startMonitoring() {
    locationManager.requestAlwaysAuthorization()
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
    motionManager.startAccelerometerUpdates(to: OperationQueue()) { data, error in
      if let x = data?.acceleration.x, x > 1 {
        debugPrint("X bump")
      }
      if let y = data?.acceleration.y, y > 1 {
        debugPrint("Y bump")
      }
      if let z = data?.acceleration.z, z > 1 {
        debugPrint("Z bump")
      }
    }
  }
}

extension LocationManager: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    guard status == .authorizedAlways else { return }
    locationManager.startUpdatingLocation()
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.first else { return }
    currentLocation = location
  }
}
