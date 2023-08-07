//
//  ImagePageViewController.swift
//  ImagesSearch
//
//  Created by Olya Sabadina on 2023-07-24.
//

import UIKit
import SDWebImage

class ImagePageViewController: UIViewController {
    
    private let networkManager = NetworkManager()
    private let previewImageView = PreviewImageView()
    private var imageDescription: ImageDescription
    let topView  = TopView()
    let downView = BottomCollectionView()
    var sortType: SortModel = .none
    
    var completion: ((String) -> Void)?
    var arrayImages: [ImageDescription]? = nil {
        didSet {
            downView.bottomCollectionView.reloadData()
        }
    }
    
    //MARK: - Init:
    
    init(_ hit: ImageDescription) {
        self.imageDescription = hit
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
        networkManager.downloadImageFromUrl(imageDescription.largeImageURL) { result in
            switch result {
            case .success(let img):
                DispatchQueue.main.async {
                    let imageVC = ZoomImageViewController(img)
                    self.navigationController?.pushViewController(imageVC, animated: true)
                }
            case .failure(_):
                print(NetworkErrors.badURLtoImage)
            }
        }
    }
    
    @objc func sharePreviewImage() {
        let url = imageDescription.previewURL
        shareFromURL(url)
    }
    
    @objc func downloadImageAction() {
        alertDownload()
    }
    
    @objc func backToPreviousVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func imageSaveToPhotoLibrary(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            createAlert(error.localizedDescription)
        } else {
            createAlert(TitleConstants.saveToGallary)
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
        let alert = UIAlertController(title: TitleConstants.chooseSize, message: nil, preferredStyle: .actionSheet)
        let previewSizeAction = UIAlertAction(title: TitleConstants.previewSize, style: .default) { _  in
            self.downloadImageToGallery(self.imageDescription.previewURL)
        }
        let webFormatAction = UIAlertAction(title: TitleConstants.webSize, style: .default) { _  in
            self.downloadImageToGallery(self.imageDescription.webformatURL)
        }
        let largeSizeAction = UIAlertAction(title: TitleConstants.largeSize, style: .default) { _  in
            self.downloadImageToGallery(self.imageDescription.largeImageURL)
        }
        let cancelAction = UIAlertAction(title: TitleConstants.cancel, style: .destructive)
        alert.addAction(previewSizeAction)
        alert.addAction(webFormatAction)
        alert.addAction(largeSizeAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func downloadImageToGallery(_ urlSize: String) {
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
        let okAction = UIAlertAction(title: TitleConstants.Ok, style: .default)
        alert.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    private func configureView() {
        let currentImageUrl = imageDescription.previewURL
        guard let url = URL(string: currentImageUrl) else {return}
        previewImageView.imageView.sd_setImage(with: url, placeholderImage: nil, options: [.continueInBackground, .progressiveLoad], completed: nil)
    }
    
    private func addTargetForButton() {
        topView.backButton.addTarget(self, action: #selector(backToPreviousVC), for: .touchUpInside)
        previewImageView.zoomButton.addTarget(self, action: #selector(zoomImage), for: .touchUpInside)
        previewImageView.shareButton.addTarget(self, action: #selector(sharePreviewImage), for: .touchUpInside)
        previewImageView.downloadButton.addTarget(self, action: #selector(downloadImageAction), for: .touchUpInside)
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
        view.addSubview(previewImageView)
        previewImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setCollectionView() {
        view.addSubview(downView)
        downView.translatesAutoresizingMaskIntoConstraints = false
        downView.bottomCollectionView.register(BottomCollectionCell.self, forCellWithReuseIdentifier: BottomCollectionCell.identCell)
        downView.bottomCollectionView.delegate = self
        downView.bottomCollectionView.dataSource = self
    }
}

//MARK: = UICollectionView DataSource and Delegate

extension ImagePageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrayImages?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BottomCollectionCell.identCell, for: indexPath) as? BottomCollectionCell else {return UICollectionViewCell()}
        cell.imageDescription = arrayImages?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? BottomCollectionCell
        guard let newImage = cell?.imageDescription else {return}
        imageDescription = newImage
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
            
            previewImageView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            previewImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            previewImageView.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            previewImageView.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            
            downView.topAnchor.constraint(equalTo: previewImageView.bottomAnchor),
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
