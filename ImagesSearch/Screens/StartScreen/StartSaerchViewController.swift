//
//  ViewController.swift
//  ImagesSearch
//
//  Created by Olya Sabadina on 2023-06-14.
//

import UIKit

class StartSaerchViewController: UIViewController {
    
    let backgroundImageView = UIImageView()
    let titleLabel = UILabel()
    let downLabel = UILabel()
    let searchTextField = UITextField()
    let searchButton = UIButton(type: .system)
    let imagesSearchButton = UIButton()
    var findImageByType: ImageType = .all {
        didSet {
            imagesSearchButton.setTitle(findImageByType.rawValue.capitalized, for: .normal)
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
        let findPictureVC = FindPictureViewController()
        let findWord = searchTextField.text ?? ""
        findPictureVC.findImageByType = findImageByType
        findPictureVC.findPicturesByWord(findWord, findImageByType)
        searchTextField.text = nil
        navigationController?.pushViewController(findPictureVC, animated: true)
    }
}
//MARK: - TextFieldDelegate:

extension StartSaerchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        openFindPictureVC()
        view.endEditing(true)
        return true
    }
}



