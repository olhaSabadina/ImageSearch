//
//  ViewController.swift
//  ImagesSearch
//
//  Created by Olya Sabadina on 2023-06-14.
//

import UIKit

class StartViewController: UIViewController {
    
    private let backgroundImageView = UIImageView()
    private let titleLabel = UILabel()
    private let searchTextField = UITextField()
    private let searchButton = UIButton(type: .system)
    private let imagesSearchButton = UIButton()
    
    
    // MARK: - Life cycle:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        
    }
    
    //MARK: - @objc func:
    @objc private func tapButtonOnTF() {
        print("tapButtonOnTF")
    }
    
    //MARK: - private func:
    
}

//MARK: - TextFieldDelegate:

extension StartViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

//MARK: - Set UIConfiguration & constraints:

extension StartViewController {
    
    private enum SetImages {
        static let magnifyingglass  = UIImage(systemName: "magnifyingglass")
        static let separator        = UIImage(systemName: "poweron")
        static let chevronDown      = UIImage(systemName: "chevron.down")
    }
    
    private func configView() {
        setUpView()
        setBackgroundImageView()
        setTitleLabel()
        setSearchTextField()
        setImagesSearchButton()
        setLeftButtonOnTextField()
        setRightButtonOnTextField()
        setupSearchButton()
        setConstraints()
    }
    
    private func setUpView() {
        view.backgroundColor = .white
    }
    
    private func setBackgroundImageView() {
        backgroundImageView.image = UIImage(named: "8a9f2adb9b92e59c0d47bf7733a08f57")
        backgroundImageView.frame = view.bounds
        view.addSubview(backgroundImageView)
    }
    
    private func setTitleLabel() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 35)
        titleLabel.textAlignment = .center
        titleLabel.text = "Send your audience \n on a visual \n adventure"
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0
        titleLabel.sizeToFit()
        titleLabel.backgroundColor = .clear
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
    }
    
    private func setSearchTextField() {
        searchTextField.delegate = self
        searchTextField.placeholder = " search "
        searchTextField.font = .systemFont(ofSize: 18)
        searchTextField.autocapitalizationType = .none
        searchTextField.autocorrectionType = .no
        searchTextField.borderColorRadius(borderWidth: 1, cornerRadius: 8, borderColor: .black)
        searchTextField.backgroundColor = .secondarySystemBackground
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchTextField)
    }
    
    private func setLeftButtonOnTextField() {
        let leftButton = UIButton()
        leftButton.setImage(SetImages.magnifyingglass, for: .normal)
        leftButton.tintColor = .secondaryLabel
        leftButton.frame = CGRect(x: 10, y: 8, width: 20, height: 20)
//            leftButton.addTarget(self, action: #selector(), for: .touchUpInside)
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 34, height: 34))
        leftView.addSubview(leftButton)
        searchTextField.leftViewMode = UITextField.ViewMode.always
        searchTextField.leftView = leftView
    }
    
    private func setRightButtonOnTextField() {
        let separatorImage = SetImages.separator
        let separatorImageView = UIImageView(image: separatorImage)
        separatorImageView.tintColor = .secondaryLabel
        let stackView = UIStackView(arrangedSubviews: [separatorImageView,imagesSearchButton])
        stackView.axis = .horizontal
        stackView.frame = CGRect(x: 0, y: 5, width: 80, height: 30)
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        rightView.addSubview(stackView)
        searchTextField.rightViewMode = UITextField.ViewMode.always
        searchTextField.rightView = rightView
    }
    
    private func setImagesSearchButton() {
        imagesSearchButton.setTitle("Images", for: .normal)
        imagesSearchButton.setTitleColor(.secondaryLabel, for: .normal)
        imagesSearchButton.setImage(SetImages.chevronDown, for: .normal)
        imagesSearchButton.titleLabel?.font = .systemFont(ofSize: 15)
        imagesSearchButton.tintColor = .secondaryLabel
        imagesSearchButton.titleLabel?.adjustsFontSizeToFitWidth = true
        imagesSearchButton.semanticContentAttribute = .forceRightToLeft
        imagesSearchButton.addTarget(self, action: #selector(tapButtonOnTF), for: .touchUpInside)
    }
    
    private func setupSearchButton(){
        searchButton.setTitle("  Search", for: .normal)
        searchButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        searchButton.setImage(SetImages.magnifyingglass, for: .normal)
        searchButton.setTitleColor(.white, for: .normal)
        searchButton.tintColor = .white
        searchButton.backgroundColor = .blue
        searchButton.borderColorRadius(borderWidth: 1, cornerRadius: 8, borderColor: .black)
//            searchButton.addTarget(self, action: #selector(), for: .touchUpInside)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchButton)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleLabel.topAnchor.constraint(equalTo:view.topAnchor, constant: 200),
            
            searchTextField.heightAnchor.constraint(equalToConstant: 50),
            searchTextField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            searchTextField.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            searchTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            
            searchButton.heightAnchor.constraint(equalToConstant: 50),
            searchButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            searchButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            searchButton.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 30)
        ])
    }
    
}


