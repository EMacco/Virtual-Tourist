//
//  UIView+Extension.swift
//  VirtualTourist
//
//  Created by Emmanuel Okwara on 18/01/2020.
//  Copyright © 2020 Emmanuel Okwara. All rights reserved.
//

import UIKit

extension UIView {
  func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
    layer.masksToBounds = false
    layer.shadowColor = color.cgColor
    layer.shadowOpacity = opacity
    layer.shadowOffset = offSet
    layer.shadowRadius = radius

    layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    layer.shouldRasterize = true
    layer.rasterizationScale = scale ? UIScreen.main.scale : 1
  }
}
