//
//  UITextField+Extension.swift
//  ImagesSearch
//
//  Created by Olya Sabadina on 2023-07-28.
//

import UIKit

extension UITextField {

    func setLeftImageOnTextField(_ image: UIImage?, tintColor: UIColor) {
        let leftImage = UIImageView(image: image)
        leftImage.tintColor = tintColor
        leftImage.frame = CGRect(x: 10, y: 8, width: 20, height: 20)
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 34, height: 34))
        leftView.addSubview(leftImage)
        self.leftViewMode = UITextField.ViewMode.always
        self.leftView = leftView
    }
}
