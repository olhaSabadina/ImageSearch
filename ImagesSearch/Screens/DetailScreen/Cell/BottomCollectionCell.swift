//
//  BottomCollectionCell.swift
//  ImagesSearch
//
//  Created by Olya Sabadina on 2023-07-27.
//

import UIKit

class BottomCollectionCell: UICollectionViewCell {

    static var identCell = "SmallCell"
  
    private let previewImage = UIImageView()
   
    var imageDescription: ImageDescription? = nil {
        didSet {
            updateCellImage(imageDescription?.previewURL)
        }
    }
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        configureImage()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        previewImage.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        previewImage.image = nil
    }
    
    private func configureImage() {
        addSubview(previewImage)
        previewImage.contentMode = .scaleAspectFill
        previewImage.clipsToBounds = true
    }
    
    private func updateCellImage(_ urlWeb: String?) {
        guard let url = URL(string: urlWeb ?? "") else {return}
        previewImage.sd_setImage(with: url, placeholderImage: nil, options: [.continueInBackground, .progressiveLoad], completed: nil)
    }
}
