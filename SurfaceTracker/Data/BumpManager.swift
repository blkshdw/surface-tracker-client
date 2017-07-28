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

private let accelerometerUpdateInterval: TimeInterval = 0.2

class BumpManager: NSObject {
  static let instance = BumpManager()

  let motionManager = CMMotionManager()
  let locationManager = CLLocationManager()

  var currentLocation: CLLocation? = nil

  private var isMonitoring: Bool = false

  var countedBumps: [Bump] = [] {
    didSet {
      guard countedBumps.count % 100 == 0 else { return }
      NotificationManager.show("Bumps saved: \(countedBumps.count)")
      StorageHelper.save(countedBumps.toJSONString(), forKey: .bumps)
    }
  }

  var potholes: [Bump] {
    let filteredBumps = countedBumps
      .filter({ $0.acceleration != nil && $0.acceleration!.amplitude > BumpType.light.rawValue})
    return clusterBumps(filteredBumps)
  }

  private override init() {
    super.init()
    self.isMonitoring = Configuration.current.debugMode
    if let bumpsJSON: String = StorageHelper.loadObjectForKey(.bumps) {
      self.countedBumps = Mapper<Bump>().mapArray(JSONString: bumpsJSON) ?? []
      debugPrint("Bumps loaded: \(countedBumps.count)")
      NotificationManager.show("Bumps loaded: \(countedBumps.count)")
      _ = sendSavedBumps()
    }
    motionManager.accelerometerUpdateInterval = accelerometerUpdateInterval
    locationManager.delegate = self
  }

  func clusterBumps(_ oldBumps: [Bump]) -> [Bump] {
    var bumps: [Bump] = []
    debugPrint("Bumps count: \(bumps.count)")
    for bump in oldBumps.sorted(by: { $0.date < $1.date }) {
      guard let lastBump = bumps.last, bump.date.timeIntervalSince(lastBump.date) < 1 else {
        bumps.append(bump)
        continue
      }
      guard let lastAcceleration = lastBump.acceleration, let currentAcceleration = bump.acceleration else { continue }
      lastBump.acceleration = Acceleration.average(lastAcceleration, currentAcceleration)
    }
    return bumps
  }

  func sendSavedBumps() {
    _ = DataManager.sendSavedBumps(potholes)
  }

  func startMonitoring() {
    guard Configuration.current.debugMode else { return }
    guard !isMonitoring else { return resetMonitoring() }

    locationManager.requestAlwaysAuthorization()
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()

    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    motionManager.startAccelerometerUpdates(to: OperationQueue()) { data, error in
      let newBump = Bump(location: self.currentLocation?.coordinate, acceleration: data?.acceleration)
      if let acceleration = newBump.acceleration, acceleration.amplitude > BumpType.light.rawValue {
        self.countedBumps.append(newBump)

        let notificationBody = "x: \(acceleration.x),  y: \(acceleration.y), z: \(acceleration.z)"
        NotificationManager.show("Bump?",
                                 subtitle: "Amplitude: \(acceleration.amplitude)",
                                 body: notificationBody)
      }
    }
    isMonitoring = true
  }

  func stopMonitoring() {
    guard isMonitoring else { return }
    locationManager.stopUpdatingLocation()
    motionManager.stopAccelerometerUpdates()
    isMonitoring = false
  }

  func resetMonitoring() {
    stopMonitoring()
    startMonitoring()
  }
  
}

extension BumpManager: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    guard status == .authorizedAlways else { return }
    locationManager.startUpdatingLocation()
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.first else { return }
    currentLocation = location
  }
}
