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
    private var stackView = UIStackView()
    private let searchButton = UIButton(type: .system)
    private var separator = UIImageView()
    private let imagesSearchButton = UIButton(type: .system)

    
    // MARK: - Life cycle:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        
    }
    
    //MARK: - @objc func:
    
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
        
        private func configView() {
            setUpView()
            setBackgroundImageView()
            setTitleLabel()
            setSearchTextField()
            setLeftButtonOnTextField()
            setRightButtonOnTextField()
//            comfigStackView()
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
            leftButton.setImage(UIImage(named: "magnifyingglassGrey"), for: .normal)
            leftButton.frame = CGRect(x: 10, y: 8, width: 20, height: 20)
//            leftButton.addTarget(self, action: #selector(), for: .touchUpInside)
            let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 34, height: 34))
            leftView.addSubview(leftButton)
            searchTextField.leftViewMode = UITextField.ViewMode.always
            searchTextField.leftView = leftView
        }
        
        private func setRightButtonOnTextField() {
            stackView.frame = CGRect(x: 0, y: 8, width: 40, height: 20)
//            stackView.addTarget(self, action: #selector(), for: .touchUpInside)
            let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 34))
            rightView.addSubview(stackView)
            searchTextField.rightViewMode = UITextField.ViewMode.always
            searchTextField.rightView = rightView
        }
        
        private func comfigStackView() {
            stackView = UIStackView(arrangedSubviews: [separator, imagesSearchButton])
            stackView.backgroundColor = .black
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            stackView.spacing = 2
//            view.addSubview(stackView)
        }
        private func setSeparator() {
            separator.image = UIImage(named: "div vertical")
            
        }
        
        
        private func setImagesSearchButton() {
            imagesSearchButton.setTitle("Images", for: .normal)
            imagesSearchButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            imagesSearchButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
            imagesSearchButton.semanticContentAttribute = .forceRightToLeft
        }
        
        
        
        
        
        
        private func setupSearchButton(){
            searchButton.setTitle("Search", for: .normal)
            searchButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
            searchButton.setImage(UIImage(named: "magnifyingglassWhite"), for: .normal)
            searchButton.setTitleColor(.white, for: .normal)
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
    

