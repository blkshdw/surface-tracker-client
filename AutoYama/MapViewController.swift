//
//  MapViewController.swift
//  AutoYama
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
    LocationManager.instance.startMonitoring()
    mapView.isMyLocationEnabled = true
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

