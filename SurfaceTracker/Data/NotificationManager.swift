//
//  NotificationManager.swift
//  SurfaceTracker
//
//  Created by Алексей on 11.06.17.
//  Copyright © 2017 tetofa. All rights reserved.
//

import Foundation
import UserNotifications
import UserNotificationsUI

private let categoryIdentifier = "alertCategory"

class NotificationManager {

  static func show(_ title: String = "Alert!", subtitle: String = "Do not tap", body: String = "  ") {
    guard Configuration.current.pushNotificationEnabled else { return }

    let content = UNMutableNotificationContent()
    content.title = title
    content.subtitle = subtitle
    content.body = body
    content.badge = 1
    content.categoryIdentifier = categoryIdentifier

    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

    let requestIdentifier = categoryIdentifier
    let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
      guard let error = error else { return }
      debugPrint(error)
    })
  }

}
