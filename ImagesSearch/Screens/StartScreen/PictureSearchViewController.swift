//
//  ViewController.swift
//  ImagesSearch
//
//  Created by Olya Sabadina on 2023-06-14.
//

import UIKit

class PictureSearchViewController: UIViewController {
    
    let titleLabel = UILabel()
    let downLabel = UILabel()
    let imagesTypeButton = UIButton()
    let searchButton = UIButton(type: .system)
    let searchTextField = UITextField()
    let backgroundImageView = UIImageView()
    var menuTypeImage: MenuBuilder?
    var imageType: ImageType = .all {
        didSet {
            imagesTypeButton.setTitle(imageType.rawValue.capitalized, for: .normal)
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
    
//MARK: - @objc func:
    
    @objc func openFindPictureVC() {
        let findPictureVC = ListPictureViewController()
        let findWord = searchTextField.text ?? ""
        findPictureVC.findImageByType = imageType
        findPictureVC.findPicturesByWord(findWord, imageType)
        searchTextField.text = nil
        navigationController?.pushViewController(findPictureVC, animated: true)
    }
}
//MARK: - TextFieldDelegate:

extension PictureSearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        openFindPictureVC()
        view.endEditing(true)
        return true
    }
}



