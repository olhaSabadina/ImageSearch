//
//  UIView+Extension.swift
//  ImagesSearch
//
//  Created by Olya Sabadina on 2023-06-15.
//

import UIKit

extension UIView {
    func setBorderLayer(backgroundColor: UIColor, borderColor: UIColor, borderWidth: CGFloat, cornerRadius: CGFloat, tintColor: UIColor?) {
        self.backgroundColor = backgroundColor
        self.tintColor = tintColor
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        layer.cornerRadius = cornerRadius
    }
}
