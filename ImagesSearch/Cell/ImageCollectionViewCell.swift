//
//  ImageCollectionViewCell.swift
//  ImagesSearch
//
//  Created by Olya Sabadina on 2023-06-18.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    static let imageCellIdentifier = "imageCell"
    
    private let pictureView = UIView()
    private var pictureImage = UIImage()

    
    override init(frame: CGRect) {
        super .init(frame: frame)
        contentView.contentMode = .center
        contentView.addSubview(pictureView)
        
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        pictureView.frame = contentView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
