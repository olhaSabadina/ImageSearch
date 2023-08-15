//
//  PaddedLabel.swift
//  ImagesSearch
//
//  Created by Olya Sabadina on 2023-07-20.
//

import UIKit

final class PaddedLabel: UILabel {
    
    var padding: UIEdgeInsets = .zero
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override var intrinsicContentSize : CGSize {
        let sz = super.intrinsicContentSize
        return CGSize(width: sz.width + padding.left + padding.right, height: sz.height + padding.top + padding.bottom)
    }
}
