//
//  MapViewController.swift
//  SurfaceTracker
//
//  Created by Алексей on 11.04.17.
//  Copyright © 2017 tetofa. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

private let cityZoom: Float = 10

class MapViewController: UIViewController {
  let locationManager = CLLocationManager()
  @IBOutlet weak var mapView: GMSMapView!

  override func viewDidLoad() {
    super.viewDidLoad()
    mapView.isMyLocationEnabled = true

    configureMap()
  }

  func configureMap() {
    DataManager.fetchBumps().then { [weak self] bumps in
      for bump in bumps {
        guard let position = bump.location?.coordinates else { continue }
        let circle = GMSCircle(position: position, radius: 10)
        circle.strokeWidth = 0
        circle.fillColor = bump.bumpType?.color
        circle.map = self?.mapView
      }
    }

    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.delegate = self
    locationManager.startUpdatingLocation()

  }

}

extension MapViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let coordinate = locations.last?.coordinate else { return }
    locationManager.stopUpdatingLocation()
    mapView.camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: cityZoom)

  }
}

