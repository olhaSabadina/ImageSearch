//
//  ImagePageViewController.swift
//  ImagesSearch
//
//  Created by Olya Sabadina on 2023-07-24.
//

import UIKit
import SDWebImage

class DetailPictureViewController: UIViewController {
    
    private let networkManager = NetworkManager()
    private let previewImageView = PreviewImageView()
    private var imageDescription: ImageDescription
    
    let topView  = TopView()
    let bottomCollectionView = BottomCollectionView()
    var menuSort: MenuBuilder?
    var sortType: SortImageType = .none
    var completion: ((String) -> Void)?
    var imageDescriptionArray: [ImageDescription]? = nil {
        didSet {
            bottomCollectionView.bottomCollectionView?.reloadData()
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
        setMenu()
        addTargetForButton()
        addTapGestureToHideKeyboard()
        configureView()
        setCollectionView()
        setConstraint()
    }
    
    //MARK: - @objc func:
    
    @objc func cropImage() {
        zoomImage()
        
        
    }
    
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
        presentAlertWithTitle(title: TitleConstants.chooseSize, message: nil, options: TitleConstants.previewSize, TitleConstants.webSize, TitleConstants.largeSize,TitleConstants.cancel, styleActionArray: [.default, .default, .default, .destructive], alertStyle: .actionSheet) { numberButton in
            switch numberButton {
            case 0: self.downloadImageToGallery(self.imageDescription.previewURL)
            case 1:
                self.downloadImageToGallery(self.imageDescription.webformatURL)
            case 2:
                self.downloadImageToGallery(self.imageDescription.largeImageURL)
            default:
                break
            }
        }
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
        presentAlertWithTitle(title: title, message: nil, options: TitleConstants.Ok, styleActionArray: [.default], alertStyle: .alert, completion: nil)
    }
    
    private func configureView() {
        let currentImageUrl = imageDescription.previewURL
        guard let url = URL(string: currentImageUrl) else {return}
        previewImageView.imageView.sd_setImage(with: url, placeholderImage: nil, options: [.continueInBackground, .progressiveLoad], completed: nil)
    }
    
    private func setMenu() {
        menuSort = MenuBuilder(sortType, topView, imageDescriptionArray)
        menuSort?.completionArrayTypeSort = { imgData in
            self.sortType = imgData.sortImageType
            self.imageDescriptionArray = imgData.imagesArray
        }
    }
    
    private func addTargetForButton() {
        topView.backButton.addTarget(self, action: #selector(backToPreviousVC), for: .touchUpInside)
        previewImageView.cropButton.addTarget(self, action: #selector(cropImage), for: .touchUpInside)
        
        previewImageView.zoomButton.addTarget(self, action: #selector(zoomImage), for: .touchUpInside)
        previewImageView.shareButton.addTarget(self, action: #selector(sharePreviewImage), for: .touchUpInside)
        previewImageView.downloadButton.addTarget(self, action: #selector(downloadImageAction), for: .touchUpInside)
        topView.sortedButton.menu = menuSort?.sortingImageMenu()
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
        view.addSubview(bottomCollectionView)
        bottomCollectionView.translatesAutoresizingMaskIntoConstraints = false
        bottomCollectionView.bottomCollectionView?.register(BottomCollectionCell.self, forCellWithReuseIdentifier: BottomCollectionCell.identCell)
        bottomCollectionView.bottomCollectionView?.delegate = self
        bottomCollectionView.bottomCollectionView?.dataSource = self
    }
}

//MARK: = UICollectionView DataSource and Delegate

extension DetailPictureViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageDescriptionArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BottomCollectionCell.identCell, for: indexPath) as? BottomCollectionCell else {return UICollectionViewCell()}
        cell.imageDescription = imageDescriptionArray?[indexPath.item]
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

extension DetailPictureViewController {
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
            
            bottomCollectionView.topAnchor.constraint(equalTo: previewImageView.bottomAnchor),
            bottomCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

//MARK: - TextFieldDelegate:

extension DetailPictureViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        completion?(topView.textField.text ?? "")
        navigationController?.popViewController(animated: true)
        view.endEditing(true)
        return true
    }
}
