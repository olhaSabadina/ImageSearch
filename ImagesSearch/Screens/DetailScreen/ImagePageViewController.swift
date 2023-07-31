//
//  ImagePageViewController.swift
//  ImagesSearch
//
//  Created by Olya Sabadina on 2023-07-24.
//

import UIKit

class ImagePageViewController: UIViewController {
    
    private let networkManager = NetworkManager()
    let topView  = TopView()
    private let largeImageView = LargeImageView()
    let downView = SmallCollectionView()
    var sortType: SortByEnum = .none
    private var hit: Hit
    
    var completion: ((String) -> Void)?
    var arrayHits: [Hit]? = nil {
        didSet {
            downView.smalCollectionView.reloadData()
        }
    }
    
    //MARK: - Init:
    
    init(_ hit: Hit) {
        self.hit = hit
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTopView()
        setLargeImageView()
        addTargetForButton()
        addTapGestureToHideKeyboard()
        configureView()
        setCollectionView()
        setConstraint()
    }
    
    //MARK: - @objc func:
    
    @objc func zoomImage() {
        networkManager.downloadImageFromUrl(hit.largeImageURL) { result in
            switch result {
            case .success(let img):
                DispatchQueue.main.async {
                    let imageVC = ImageViewController(img)
                    self.navigationController?.pushViewController(imageVC, animated: true)
                }
            case .failure(_):
                print(NetworkErrors.badURLtoImage)
            }
        }
    }
    
    @objc func sharePreviewImage() {
        let url = hit.previewURL
        navigationController?.viewControllers.forEach({ item in
            if let findVC = item as? FindPictureViewController {
                findVC.shareURL(url)
            }
        })
    }
    
    @objc func downloadImageActoin() {
        alertDownload()
    }
    
    @objc func backToPreviousVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func imageSaveToPhotoLibrary(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            createAlert(error.localizedDescription)
        } else {
            createAlert(TitleEnum.alertTitleSaveToGallary)
        }
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: -  private func:
    
    private func addTapGestureToHideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    private func alertDownload() {
        let alert = UIAlertController(title: TitleEnum.alertTitleChooseSize, message: nil, preferredStyle: .actionSheet)
        let previewSizeAction = UIAlertAction(title: TitleEnum.alertPreviewSize, style: .default) { _  in
            self.downloadImageToGallary(self.hit.previewURL)
        }
        let webFormatAction = UIAlertAction(title: TitleEnum.alertWebSize, style: .default) { _  in
            self.downloadImageToGallary(self.hit.webformatURL)
        }
        let largeSizeAction = UIAlertAction(title: TitleEnum.alertLargeSize, style: .default) { _  in
            self.downloadImageToGallary(self.hit.largeImageURL)
        }
        let cancelAction = UIAlertAction(title: TitleEnum.alertCancelButton, style: .destructive)
        alert.addAction(previewSizeAction)
        alert.addAction(webFormatAction)
        alert.addAction(largeSizeAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func downloadImageToGallary(_ urlSize: String) {
        networkManager.downloadImageFromUrl(urlSize) { result in
            switch result {
            case .success(let image):
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.imageSaveToPhotoLibrary(_:didFinishSavingWithError:contextInfo:)), nil)
                
            case .failure(_):
                print(NetworkErrors.errorDownloadImage)
            }
        }
    }
    
    private func createAlert(_ title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: TitleEnum.alertOkButton, style: .default)
        alert.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    private func configureView() {
        networkManager.downloadImageFromUrl(hit.previewURL) { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.largeImageView.imageView.image = image
                }
            case .failure(_):
                print(NetworkErrors.errorDownloadImage)
            }
        }
    }
    
    private func addTargetForButton() {
        topView.backButton.addTarget(self, action: #selector(backToPreviousVC), for: .touchUpInside)
        largeImageView.zoomButton.addTarget(self, action: #selector(zoomImage), for: .touchUpInside)
        largeImageView.shareButton.addTarget(self, action: #selector(sharePreviewImage), for: .touchUpInside)
        largeImageView.downloadButton.addTarget(self, action: #selector(downloadImageActoin), for: .touchUpInside)
        topView.sortedButton.menu = interactiveSortMenu()
    }
    
    private func setTopView() {
        topView.textField.delegate = self
        topView.translatesAutoresizingMaskIntoConstraints = false
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
        view.addSubview(topView)
    }
    
    private func setLargeImageView() {
        view.addSubview(largeImageView)
        largeImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setCollectionView() {
        view.addSubview(downView)
        downView.translatesAutoresizingMaskIntoConstraints = false
        downView.smalCollectionView.register(SmallCell.self, forCellWithReuseIdentifier: SmallCell.identCell)
        downView.smalCollectionView.delegate = self
        downView.smalCollectionView.dataSource = self
    }
}

//MARK: = UICollectionView DataSource and Delegate

extension ImagePageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrayHits?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SmallCell.identCell, for: indexPath) as? SmallCell else {return UICollectionViewCell()}
        cell.hit = arrayHits?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? SmallCell
        guard let newHit = cell?.hit else {return}
        hit = newHit
        configureView()
    }
}

//  MARK: - SetConstraint:

extension ImagePageViewController {
    func setConstraint() {
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topView.heightAnchor.constraint(equalToConstant: 80),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            largeImageView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            largeImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            largeImageView.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            largeImageView.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            
            downView.topAnchor.constraint(equalTo: largeImageView.bottomAnchor),
            downView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            downView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            downView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

//MARK: - TextFieldDelegate:

extension ImagePageViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        completion?(topView.textField.text ?? "")
        navigationController?.popViewController(animated: true)
        view.endEditing(true)
        return true
    }
}
