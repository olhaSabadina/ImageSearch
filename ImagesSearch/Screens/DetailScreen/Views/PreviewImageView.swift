//
//  PreviewImageView.swift
//  ImagesSearch
//
//  Created by Olya Sabadina on 2023-07-24.
//

import UIKit

class PreviewImageView: UIView {

    let imageView = UIImageView()
    let zoomButton = UIButton(type: .system)
    let downloadButton = UIButton(type: .system)
    let shareButton = UIButton(type: .system)
    
    private var mainStack = UIStackView()
    private let formatPhotoLabel  = UILabel()
    private let licenseLabel = UILabel()
    private let commercialLabel = UILabel()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setImageView()
        setLabelsStackView()
        setAttributePhotoLabels()
        setFormatPhotoLabel()
        setShareButton()
        setZoomButton()
        setDownloadButton()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setImageView() {
        imageView.setBorderLayer(backgroundColor: .lightGray, borderColor: .black, borderWidth: 1, cornerRadius: 0, tintColor: nil)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        addSubview(imageView)
    }
    
    private func setLabelsStackView() {
        let leftLabelStack = UIStackView(arrangedSubviews: [licenseLabel, commercialLabel])
        leftLabelStack.axis = .vertical
        leftLabelStack.distribution = .fillEqually
        leftLabelStack.spacing = 5
       
        let rightLabelStack = UIStackView(arrangedSubviews: [formatPhotoLabel, shareButton])
        rightLabelStack.axis = .vertical
        rightLabelStack.distribution = .fillEqually
        rightLabelStack.spacing = 5
        
        mainStack = UIStackView(arrangedSubviews: [leftLabelStack, rightLabelStack])
        mainStack.axis = .horizontal
        mainStack.spacing = 20
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainStack)
    }
    
    private func setAttributePhotoLabels() {
        let arraylabels = [licenseLabel, commercialLabel]
        
        arraylabels.forEach { label in
            label.font = .systemFont(ofSize: 15)
            label.textAlignment = .left
        }
        
        licenseLabel.text = "APP License"
        licenseLabel.textColor = .systemIndigo
        
        commercialLabel.text = "Free for commercial use\n No attribution required"
        commercialLabel.textColor = .lightGray
        commercialLabel.numberOfLines = 2
    }
    
    private func setFormatPhotoLabel() {
        formatPhotoLabel.text = "Photo in .JPG format"
        formatPhotoLabel.font = .systemFont(ofSize: 15)
        formatPhotoLabel.textColor = .black
        formatPhotoLabel.textAlignment = .left
    }
    
    private func setShareButton() {
        shareButton.setTitle(TitleConstants.share, for: .normal)
        shareButton.setImage(ImageConstants.share, for: .normal)
        shareButton.setBorderLayer(backgroundColor: .init(red: 107, green: 86, blue: 223, alpha: 1),
                                   borderColor: .darkGray,
                                   borderWidth: 1,
                                   cornerRadius: 4,
                                   tintColor: .black)
    }
    
    private func setZoomButton() {
        zoomButton.setImage(ImageConstants.zoom, for: .normal)
        zoomButton.translatesAutoresizingMaskIntoConstraints = false
        zoomButton.setBorderLayer(backgroundColor: .init(
            cgColor: .init(red: 226, green: 226, blue: 226, alpha: 1)),
                                   borderColor: .darkGray,
                                   borderWidth: 1,
                                   cornerRadius: 4,
                                  tintColor: .systemIndigo)
        addSubview(zoomButton)
    }
    
    private func setDownloadButton() {
        downloadButton.setTitle(TitleConstants.download, for: .normal)
        downloadButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        downloadButton.setImage(ImageConstants.download, for: .normal)
        downloadButton.setTitleColor(.white, for: .normal)
        downloadButton.setBorderLayer(backgroundColor: .blue, borderColor: .black, borderWidth: 1, cornerRadius: 8, tintColor: .white)
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(downloadButton)
    }
    
    private func setConstrains() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 10/16),

            mainStack.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 15),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(equalTo: downloadButton.topAnchor, constant: -15),
            
            zoomButton.heightAnchor.constraint(equalToConstant: 35),
            zoomButton.widthAnchor.constraint(equalTo: zoomButton.heightAnchor),
            zoomButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -20),
            zoomButton.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -15),
            
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            downloadButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            downloadButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.13),
            downloadButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.95)
        ])
    }
}
