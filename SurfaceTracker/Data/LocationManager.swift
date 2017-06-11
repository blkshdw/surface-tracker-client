//
//  LocationManager.swift
//  SurfaceTracker
//
//  Created by Алексей on 11.04.17.
//  Copyright © 2017 tetofa. All rights reserved.
//

import Foundation
import CoreLocation
import CoreMotion
import ObjectMapper
import PromiseKit

class LocationManager: NSObject {
  static let instance = LocationManager()

  let motionManager = CMMotionManager()
  let locationManager = CLLocationManager()

  var currentLocation: CLLocation? = nil

  var countedBumps: [Bump] = [] {
    didSet {
      guard countedBumps.count % 100 == 0 else { return }
      NotificationManager.show("Bumps saved: \(countedBumps.count)")
      StorageHelper.save(countedBumps.toJSONString(), forKey: .bumps)
    }
  }

  private override init() {
    super.init()
    if let bumpsJSON: String = StorageHelper.loadObjectForKey(.bumps) {
      self.countedBumps = Mapper<Bump>().mapArray(JSONString: bumpsJSON) ?? []
      debugPrint("Bumps loaded: \(countedBumps.count)")
      NotificationManager.show("Bumps loaded: \(countedBumps.count)")
      _ = sendSavedBumps()
    }
    motionManager.accelerometerUpdateInterval = 0.5
    locationManager.delegate = self
  }

  func resetMonitoring() {
    locationManager.stopUpdatingLocation()
    motionManager.stopAccelerometerUpdates()

    locationManager.requestAlwaysAuthorization()
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
    
    motionManager.startAccelerometerUpdates(to: OperationQueue()) { data, error in
      self.countedBumps.append(Bump(location: self.currentLocation?.coordinate, acceleration: data?.acceleration))
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


  func sendSavedBumps() -> Promise<Void> {
    var bumpsJSON = countedBumps.toJSON()
    return NetworkManager.doRequest(.sendBumps, ["bumps": bumpsJSON]).then { _ in
      debugPrint("Bumps sent: \(bumpsJSON.count)")
      NotificationManager.show("Bumps sent: \(bumpsJSON.count)")
      self.countedBumps = []
      return Promise(value: ())
    }
  }

  func fetchBumps() -> Promise<[Bump]> {
    return NetworkManager.doRequest(.fetchBumps).then { data in
      guard let bumps = Mapper<Bump>().mapArray(JSONObject: data) else { return Promise(error: DataError.unprocessableData) }
      return Promise(value: bumps)
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
