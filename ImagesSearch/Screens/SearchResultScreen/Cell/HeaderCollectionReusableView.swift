//
//  HeaderCollectionReusableView.swift
//  ImagesSearch
//
//  Created by Olya Sabadina on 2023-06-20.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
    
    static let headerIdentifier = "totalImage"
    
    private let totalImageLabel : UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        addSubview(totalImageLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        totalImageLabel.frame = bounds
    }
    
    func configTotalImageLabel( _ totalImages: Int) {
        totalImageLabel.text = "\(totalImages) Free Images"
    }
    
}
