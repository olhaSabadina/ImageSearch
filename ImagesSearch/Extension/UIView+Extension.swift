//
//  UIView+Extension.swift
//  ImagesSearch
//
//  Created by Olya Sabadina on 2023-06-15.
//

import UIKit

extension UIView {
    func borderColorRadius(borderWidth: CGFloat, cornerRadius: CGFloat, borderColor: UIColor) {
        layer.borderWidth = borderWidth
        layer.cornerRadius = cornerRadius
        layer.borderColor = borderColor.cgColor
    }
}
