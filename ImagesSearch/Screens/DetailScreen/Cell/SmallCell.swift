//
//  SmallCell.swift
//  ImagesSearch
//
//  Created by Olya Sabadina on 2023-07-27.
//

import UIKit

class SmallCell: UICollectionViewCell {

    static var identCell = "SmallCell"
  
    private let networkManager = NetworkManager()
    private let smallImage = UIImageView()
   
    var hit: Hit? = nil {
        didSet {
            updateCellImage(hit?.previewURL)
        }
    }
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        configureImage()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        smallImage.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        smallImage.image = nil
    }
    
    private func configureImage() {
        addSubview(smallImage)
        smallImage.contentMode = .scaleAspectFill
        smallImage.clipsToBounds = true
    }
    
    private func updateCellImage(_ urlWeb: String?) {
        guard let url = URL(string: urlWeb ?? "") else {return}
        smallImage.sd_setImage(with: url, placeholderImage: nil, options: [.continueInBackground, .progressiveLoad], completed: nil)
    }
}
