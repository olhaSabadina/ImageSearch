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
    private let downLabel = UILabel()
    private let searchTextField = UITextField()
    private let searchButton = UIButton(type: .system)
    private let imagesSearchButton = UIButton()
    private var typeImageFind: TypeEnum = .all {
        didSet {
            imagesSearchButton.setTitle(typeImageFind.rawValue.capitalized, for: .normal)
        }
    }
    
    
    // MARK: - Life cycle:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setConstraints()
    }
    
    @objc private func openFindPictureVC() {
        let findPictureVC = FindPictureViewController()
        let findWord = searchTextField.text ?? ""
        findPictureVC.typeImageFind = typeImageFind
        findPictureVC.findPicturesByWord(findWord, typeImageFind)
        searchTextField.text = nil
        navigationController?.pushViewController(findPictureVC, animated: true)
    }
    
    //MARK: - private func:
    
}

//MARK: - TextFieldDelegate:

extension StartViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        openFindPictureVC()
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
        setDownLabel()
        setSearchTextField()
        setImagesSearchButton()
        setLeftButtonOnTextField()
        setRightButtonOnTextField()
        setupSearchButton()
//        setConstraints()
    }
    
    private func setUpView() {
        view.backgroundColor = .white
    }
    
    private func setBackgroundImageView() {
        backgroundImageView.image = UIImage(named: "backgroundImage")
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImageView)
    }
    
    private func setTitleLabel() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 35)
        titleLabel.textAlignment = .center
        titleLabel.text = "Send your audience\n on a visual adventure"
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0
//        titleLabel.sizeToFit()
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.backgroundColor = .clear
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
    }
    
    private func setDownLabel() {
        downLabel.font = UIFont.boldSystemFont(ofSize: 13)
        downLabel.textAlignment = .center
        downLabel.text = "Photo by Free-Photos"
        downLabel.textColor = .white
        downLabel.numberOfLines = 0
        downLabel.adjustsFontSizeToFitWidth = true
        downLabel.backgroundColor = .clear
        downLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(downLabel)
    }
    
    private func setSearchTextField() {
        searchTextField.delegate = self
        searchTextField.placeholder = " search "
        searchTextField.returnKeyType = .search
        searchTextField.font = .systemFont(ofSize: 18)
        searchTextField.autocapitalizationType = .none
        searchTextField.autocorrectionType = .no
        searchTextField.setBorderLayer(backgroundColor: .secondarySystemBackground, borderColor: .black, borderWidth: 1, cornerRadius: 8, tintColor: nil)
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchTextField)
    }
    
    private func setLeftButtonOnTextField() {
        let leftButton = UIButton()
        leftButton.setImage(SetImages.magnifyingglass, for: .normal)
        leftButton.tintColor = .secondaryLabel
        leftButton.frame = CGRect(x: 10, y: 8, width: 20, height: 20)
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 34, height: 34))
        leftView.addSubview(leftButton)
        searchTextField.leftViewMode = UITextField.ViewMode.always
        searchTextField.leftView = leftView
    }
    
    private func setRightButtonOnTextField() {
        let separatorImage = SetImages.separator
        let separatorImageView = UIImageView(image: separatorImage)
        separatorImageView.widthAnchor.constraint(equalToConstant: 2).isActive = true
        separatorImageView.alpha = 0.5
        let stackView = UIStackView(arrangedSubviews: [separatorImageView,imagesSearchButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.frame = CGRect(x: 0, y: 5, width: 100, height: 30)
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 110, height: 40))
        rightView.addSubview(stackView)
        searchTextField.rightViewMode = UITextField.ViewMode.always
        searchTextField.rightView = rightView
    }
    
    private func setImagesSearchButton() {
        imagesSearchButton.setTitle(typeImageFind.labelButton, for: .normal)
        imagesSearchButton.setTitleColor(.secondaryLabel, for: .normal)
        imagesSearchButton.setImage(SetImages.chevronDown, for: .normal)
        imagesSearchButton.titleLabel?.font = .systemFont(ofSize: 15)
        imagesSearchButton.tintColor = .secondaryLabel
        imagesSearchButton.titleLabel?.adjustsFontSizeToFitWidth = true
        imagesSearchButton.semanticContentAttribute = .forceRightToLeft
        imagesSearchButton.menu = createMenu()
        imagesSearchButton.showsMenuAsPrimaryAction = true
    }
    
    private func createMenu(typePicture: String? = nil) -> UIMenu {
        let allAction = UIAction(title: TypeEnum.all.labelButton, image: UIImage(systemName: "photo.stack.fill"), attributes: .keepsMenuPresented) { action in
            self.typeImageFind = .all
            self.imagesSearchButton.menu = self.createMenu(typePicture: action.title)
        }
        let photoAction = UIAction(title: TypeEnum.photo.labelButton, image: UIImage(systemName: "photo.fill")) { action in
            self.typeImageFind = .photo
            self.imagesSearchButton.menu = self.createMenu(typePicture: action.title)
        }
        let illustrationAction = UIAction(title: TypeEnum.illustration.labelButton, image: UIImage(systemName: "circle.hexagonpath.fill")) { action in
            self.typeImageFind = .illustration
            self.imagesSearchButton.menu = self.createMenu(typePicture: action.title)
        }
        let vectorAction = UIAction(title: TypeEnum.vectorSVG.labelButton, image: UIImage(systemName: "arrow.up.forward")) { action in
            self.typeImageFind = .vectorSVG
            self.imagesSearchButton.menu = self.createMenu(typePicture: action.title)
        }
        
        let menu = UIMenu(title: "Select Image Type", image: UIImage(systemName: "filemenu.and.cursorarrow"), options: .singleSelection, children: [allAction, photoAction, illustrationAction, vectorAction])
        
        if let typePicture = typePicture {
            menu.children.forEach { action in
                guard let action = action as? UIAction else {return}
                if action.title == typePicture {
                    action.state = .on
                    action.attributes = .destructive
                }
            }
        } else {
            let action = menu.children.first as? UIAction
            action?.state = .on
        }
        
        return menu
    }
    
    private func setupSearchButton(){
        searchButton.setTitle("  Search", for: .normal)
        searchButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        searchButton.setImage(SetImages.magnifyingglass, for: .normal)
        searchButton.setTitleColor(.white, for: .normal)
        searchButton.setBorderLayer(backgroundColor: .blue, borderColor: .black, borderWidth: 1, cornerRadius: 8, tintColor: .white)
        searchButton.addTarget(self, action: #selector(openFindPictureVC), for: .touchUpInside)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchButton)
    }
    
    private func setConstraints() {
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
}


