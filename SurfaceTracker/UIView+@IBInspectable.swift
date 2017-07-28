//
//  UIView+@IBInspectable.swift
//  SurfaceTracker
//
//  Created by Алексей on 12.06.17.
//  Copyright © 2017 tetofa. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
  @IBInspectable var cornerRadius: CGFloat {
    get {
      return self.layer.cornerRadius
    }
    set {
      self.layer.cornerRadius = newValue
    }
  }

  @IBInspectable var borderWidth: CGFloat {
    get {
      return layer.borderWidth
    }
    set {
      layer.borderWidth = newValue
    }
  }

  @IBInspectable var borderColor: UIColor? {
    get {
      return UIColor(cgColor: layer.borderColor!)
    }
    set {
      layer.borderColor = newValue?.cgColor
    }
  }

  @IBInspectable var shadow: Bool {
    get {
      return layer.shadowOpacity > 0.0
    }
    set {
      if newValue {
        addShadow()
      }
    }
  }

  func addShadow(shadowColor: CGColor = UIColor.black.cgColor,
                 shadowOffset: CGSize = CGSize(width: 1.0, height: 2.0),
                 shadowOpacity: Float = 0.2,
                 shadowRadius: CGFloat = 3.0) {
    layer.shadowColor = shadowColor
    layer.shadowOffset = shadowOffset
    layer.shadowOpacity = shadowOpacity
    layer.shadowRadius = shadowRadius
  }

  func addBlur() {
    let blurEffect = UIBlurEffect(style: .light)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = bounds
    blurEffectView.clipsToBounds = true
    blurEffectView.cornerRadius = cornerRadius
    blurEffectView.alpha = 0.9
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    insertSubview(blurEffectView, at: 0)
  }

}
