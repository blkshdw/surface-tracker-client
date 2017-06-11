//
//  MapViewController.swift
//  SurfaceTracker
//
//  Created by Алексей on 11.04.17.
//  Copyright © 2017 tetofa. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
  @IBOutlet weak var mapView: GMSMapView!

  override func viewDidLoad() {
    super.viewDidLoad()
    LocationManager.instance.resetMonitoring()
    mapView.isMyLocationEnabled = true

    for bump in LocationManager.instance.countedBumps {
      guard let position = bump.location?.coordinates else { continue }
      let marker = GMSMarker(position: position)
      marker.map = mapView
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

