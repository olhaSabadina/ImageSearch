//
//  ImageCell.swift
//  ImagesSearch
//
//  Created by Olya Sabadina on 2023-06-21.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    static var identCell = "imageCell"
  
    let networkManager = NetworkFetchManager()
    var stackView = UIStackView()
    private let searchImage = UIImageView()
    let reaсtionImageView = UIImageView()
    let shareButton = UIButton()
    var countLabel = UILabel()
    var sortType: SortByEnum = .none
    var hit: Hit? = nil {
        didSet {
            setViewImage(hit, sortType)
        }
    }
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        configureImage()
        configureShareButton()
        configureStackView()
        configureReaсtionImageView()
        configureCountLabel()
        setConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        searchImage.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        searchImage.image = nil
    }
    
    func setViewImage(_ hit: Hit?, _ sortBy: SortByEnum) {
        networkManager.fetchImageFromUrl(hit?.previewURL ?? "") { result in
            switch result {
            case .success(let img):
                DispatchQueue.main.async {
                    self.searchImage.image = img
                    self.reaсtionImageView.image = sortBy.reactoinImage
                    self.countLabel.text = "\(sortBy.returnNumbers(hit))  "
                    self.stackView.isHidden = sortBy == .none ? true : false
                }
            case .failure(_):
                print(NetworkErrors.errorDownloadImage)
            }
        }
    }
    
    
    private func configureImage() {
        addSubview(searchImage)
        searchImage.contentMode = .scaleAspectFill
        searchImage.clipsToBounds = true
        searchImage.layer.cornerRadius = 7
    }
    
    private func configureShareButton() {
        addSubview(shareButton)
        shareButton.setImage(UIImage(named: "share"), for: .normal)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.setBorderLayer(backgroundColor: .init(
            cgColor: .init(red: 226, green: 226, blue: 226, alpha: 1)),
                                   borderColor: .darkGray,
                                   borderWidth: 1,
                                   cornerRadius: 4,
                                   tintColor: nil)
    }
    
    func configureStackView() {
        stackView = UIStackView(arrangedSubviews: [reaсtionImageView, countLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.setBorderLayer(backgroundColor: .black, borderColor: .black, borderWidth: 1, cornerRadius: 12, tintColor: nil)
        addSubview(stackView)
    }
    
    func configureReaсtionImageView() {
        reaсtionImageView.tintColor = .white
        reaсtionImageView.widthAnchor.constraint(equalTo: reaсtionImageView.heightAnchor).isActive = true
    }
    
    func configureCountLabel() {
        countLabel.textColor = .white
        countLabel.font = .systemFont(ofSize: 15)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            shareButton.heightAnchor.constraint(equalToConstant: 35),
            shareButton.widthAnchor.constraint(equalTo: shareButton.heightAnchor),
            shareButton.topAnchor.constraint(equalTo: searchImage.topAnchor, constant: 20),
            shareButton.trailingAnchor.constraint(equalTo: searchImage.trailingAnchor, constant: -20),
            
            stackView.heightAnchor.constraint(equalToConstant: 25),
            stackView.trailingAnchor.constraint(equalTo: searchImage.trailingAnchor, constant: -15),
            stackView.bottomAnchor.constraint(equalTo: searchImage.bottomAnchor, constant: -10)
        ])
    }
}
