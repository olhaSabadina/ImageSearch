//
//  RelatedCell.swift
//  ImagesSearch
//
//  Created by Olya Sabadina on 2023-06-20.
//

import UIKit

class SimilarImageCell: UICollectionViewCell {
    
    static var identCell = "worldCell"
    
    let labelText = PaddedLabel()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setLabel()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        labelText.backgroundColor = .clear
        labelText.textColor = .lightGray
        labelText.text = nil
    }
    
    func setTextLabel(_ indexPath: Int, textLabel: String) {
        labelText.text = textLabel
        if indexPath != 0 {
            labelText.backgroundColor = .lightGray.withAlphaComponent(0.3)
            labelText.textColor = .black
        }
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            labelText.topAnchor.constraint(equalTo: contentView.topAnchor),
            labelText.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            labelText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            labelText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    private func setLabel() {
        contentView.addSubview(labelText)
        labelText.translatesAutoresizingMaskIntoConstraints = false
        labelText.font = .systemFont(ofSize: 18)
        labelText.padding = .init(top: 4, left: 13, bottom: 4, right: 13)
        labelText.layer.cornerRadius = 4
        labelText.clipsToBounds = true
        labelText.textColor = .lightGray
        labelText.adjustsFontForContentSizeCategory = true
        labelText.sizeToFit()
    }
}
