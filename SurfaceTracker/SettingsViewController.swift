//
//  SecondViewController.swift
//  SurfaceTracker
//
//  Created by Алексей on 11.04.17.
//  Copyright © 2017 tetofa. All rights reserved.
//

import UIKit
import Eureka

class SettingsViewController: FormViewController {
  let configuration = Configuration.current
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      title: "Done",
      style: .done,
      target: self,
      action: #selector(SettingsViewController.save))
    navigationItem.rightBarButtonItem?.isEnabled = false
    configureForm()
  }

  func configureForm() {
    form +++ Section("NOTIFICATIONS")
      <<< SwitchRow() { row in
        row.title = "Push Notifications"
        row.value = configuration.pushNotificationEnabled
        }.onChange { [weak self] row in
          guard let `self` = self else { return }
          self.navigationItem.rightBarButtonItem?.isEnabled = true
          self.configuration.pushNotificationEnabled = row.value ?? true
      }

    form +++ Section("DEBUG")
      <<< SwitchRow() { row in
        row.title = "Debug Mode"
        row.value = configuration.debugMode
        configuration.debugMode = row.value ?? true
        }.onChange { [weak self] row in
          guard let `self` = self else { return }
          self.navigationItem.rightBarButtonItem?.isEnabled = true
          self.configuration.debugMode = row.value ?? true
      }

  }

  func save() {
    navigationItem.rightBarButtonItem?.isEnabled = false
    configuration.save()
  }

}

