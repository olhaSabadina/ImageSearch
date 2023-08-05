//
//  FindPictureViewController.swift
//  ImagesSearch
//
//  Created by Olya Sabadina on 2023-06-20.
//

import UIKit
import SDWebImage

class FindPictureViewController: UIViewController {
    
    private let networkManager = NetworkManager()
    
    var imagesDescription: ImagesData? = nil
    var collectionView : UICollectionView! = nil
    let topView = TopView()
    var findImageByType: ImageType = .all
    var sortType: SortModel = .none
    var imagesArray: [ImageDescription]? {
        didSet {
            collectionView.reloadData()
            collectionView.scrollRectToVisible(.init(x: 0, y: 0, width: 100, height: 100), animated: true)
        }
    }
    
    //MARK: - Life Cycle:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        setView()
        addTapGestureToHideKeyboard()
        addTargetForButtons()
        setConstraint()
    }
    
    //MARK: - Functions:
    
    func findPicturesByWord(_ findPictures: String, _ findImageType: ImageType) {
        let requestString = findPictures.replaceSpaceToPlus()
        networkManager.fetchData(findPictures: requestString, imageType: findImageByType) { result in
            switch result {
            case .success(let imgData):
                DispatchQueue.main.async {
                    self.imagesDescription = imgData
                    self.imagesArray = imgData?.hits
                }
            case .failure(_):
                self.alertNotData()
            }
        }
    }
    
    //MARK: - @objc func:
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func pushLink(_ sender: UIButton ) {
        let hitUrl = imagesArray?[sender.tag].largeImageURL ?? ""
        shareFromURL(hitUrl)
    }
    
    @objc func backToStartVC() {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - private func:
    
    private func addTapGestureToHideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    private func alertNotData() {
        let alert = UIAlertController(title: TitleConstants.noData, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: TitleConstants.Ok, style: .default) { _ in
            self.topView.textField.text = ""
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    private func addTargetForButtons() {
        topView.backButton.addTarget(self, action: #selector(backToStartVC), for: .touchUpInside)
        topView.sortedButton.menu = interactiveSortMenu()
    }
    
    // MARK: - Set view elemets:
    
    private func setView() {
        navigationController?.isNavigationBarHidden = true
        view.addSubview(topView)
        view.backgroundColor = .white
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.textField.delegate = self
    }
}
    
//MARK: - TextFieldDelegate:

extension FindPictureViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let findPicturesString = textField.text ?? ""
        findPicturesByWord(findPicturesString, findImageByType)
        view.endEditing(true)
        return true
    }
}

//  MARK: - SetConstraint:

extension FindPictureViewController {
    func setConstraint() {
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topView.heightAnchor.constraint(equalToConstant: 80),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

