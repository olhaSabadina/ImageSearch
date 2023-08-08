//
//  PictureSearchViewController+UIConfig.swift
//  ImagesSearch
//
//  Created by Olya Sabadina on 2023-07-30.
//

import UIKit

//MARK: - Set UIConfiguration & constraints:

extension PictureSearchViewController {
    
    func configView() {
        setUpView()
        setBackgroundImageView()
        setTitleLabel()
        setDownLabel()
        setSearchTextField()
        setMenu()
        setImagesSearchButton()
        setRightButtonOnTextField()
        setupSearchButton()
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleLabel.topAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 110),
            titleLabel.bottomAnchor.constraint(equalTo: searchTextField.topAnchor, constant: -30),
            
            searchTextField.heightAnchor.constraint(equalToConstant: 50),
            searchTextField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            searchTextField.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            searchTextField.topAnchor.constraint(equalTo: view.centerYAnchor),
            
            searchButton.heightAnchor.constraint(equalToConstant: 50),
            searchButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            searchButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            searchButton.topAnchor.constraint(lessThanOrEqualTo: searchTextField.bottomAnchor, constant: 30),
            
            downLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            downLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            downLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            downLabel.topAnchor.constraint(greaterThanOrEqualTo: searchButton.bottomAnchor, constant: 20)
        ])
    }
    
    private func setUpView() {
        view.backgroundColor = .white
    }
    
    private func setBackgroundImageView() {
        backgroundImageView.image = ImageConstants.background
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImageView)
    }
    
    private func setTitleLabel() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 35)
        titleLabel.textAlignment = .center
        titleLabel.text = TitleConstants.mainScreenTop
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
    }
    
    private func setDownLabel() {
        downLabel.font = UIFont.boldSystemFont(ofSize: 13)
        downLabel.textAlignment = .center
        downLabel.text = TitleConstants.mainScreenDown
        downLabel.textColor = .white
        downLabel.adjustsFontSizeToFitWidth = true
        downLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(downLabel)
    }
    
    private func setSearchTextField() {
        searchTextField.delegate = self
        searchTextField.placeholder = TitleConstants.placeholderTextField
        searchTextField.returnKeyType = .search
        searchTextField.font = .systemFont(ofSize: 18)
        searchTextField.autocapitalizationType = .none
        searchTextField.autocorrectionType = .no
        searchTextField.setBorderLayer(backgroundColor: .secondarySystemBackground, borderColor: .black, borderWidth: 1, cornerRadius: 8, tintColor: nil)
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.setLeftImageOnTextField(ImageConstants.magnifyingglass, tintColor: .secondaryLabel)
        view.addSubview(searchTextField)
    }
 
    private func setRightButtonOnTextField() {
        let separatorImageView = UIImageView(image: ImageConstants.separator)
        separatorImageView.widthAnchor.constraint(equalToConstant: 2).isActive = true
        separatorImageView.alpha = 0.5
        let stackView = UIStackView(arrangedSubviews: [separatorImageView,imagesTypeButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.frame = CGRect(x: 0, y: 5, width: 100, height: 30)
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 110, height: 40))
        rightView.addSubview(stackView)
        searchTextField.rightViewMode = UITextField.ViewMode.always
        searchTextField.rightView = rightView
    }
    
    private func setMenu() {
        menuTypeImage = MenuBuilder(imageType, imagesTypeButton)
        menuTypeImage?.completionTypeImage = { imgType in
            self.imageType = imgType
        }
    }
    
    private func setImagesSearchButton() {
        imagesTypeButton.setTitle(imageType.labelButton, for: .normal)
        imagesTypeButton.setTitleColor(.secondaryLabel, for: .normal)
        imagesTypeButton.setImage(ImageConstants.chevronDown, for: .normal)
        imagesTypeButton.titleLabel?.font = .systemFont(ofSize: 15)
        imagesTypeButton.tintColor = .secondaryLabel
        imagesTypeButton.titleLabel?.adjustsFontSizeToFitWidth = true
        imagesTypeButton.semanticContentAttribute = .forceRightToLeft
        imagesTypeButton.menu = menuTypeImage?.typeImageMenu()
        imagesTypeButton.showsMenuAsPrimaryAction = true
    }
    
    private func setupSearchButton(){
        searchButton.setTitle("  Search", for: .normal)
        searchButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        searchButton.setImage(ImageConstants.magnifyingglass, for: .normal)
        searchButton.setTitleColor(.white, for: .normal)
        searchButton.setBorderLayer(backgroundColor: .blue, borderColor: .black, borderWidth: 1, cornerRadius: 8, tintColor: .white)
        searchButton.addTarget(self, action: #selector(openFindPictureVC), for: .touchUpInside)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchButton)
    }
}
