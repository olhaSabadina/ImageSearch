//
//  ImagePageViewController.swift
//  ImagesSearch
//
//  Created by Olya Sabadina on 2023-07-24.
//

import UIKit

class ImagePageViewController: UIViewController {

    private let networkManager = NetworkFetchManager()
    private let topView  = TopView()
    private let largeImageView = LargeImageView()
    private let downView = SmallCollectionView()
    private var sortType: SortByEnum = .none
    private var hit: Hit
    var completion: ((String) -> Void)?
    var arrayHits: [Hit]? = nil {
        didSet {
            downView.smalCollectionView.reloadData()
        }
    }
    
    init(_ hit: Hit) {
        self.hit = hit
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        networkManager.downloadImage(fromLink: hit.largeImageURL) { img in
            guard let imageDownLoad = img else {return}
            DispatchQueue.main.async {
                let imageVC = ImageViewController(imageDownLoad)
                self.navigationController?.pushViewController(imageVC, animated: true)
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
            createAlert("Success download")
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
        let alert = UIAlertController(title: "Choose size for download", message: nil, preferredStyle: .actionSheet)
        let previewSizeAction = UIAlertAction(title: "Preview size", style: .default) { _  in
            self.downloadImage(self.hit.previewURL)
        }
        let webFormatAction = UIAlertAction(title: "Web Format size", style: .default) { _  in
            self.downloadImage(self.hit.webformatURL)
        }
        let largeSizeAction = UIAlertAction(title: "Large size", style: .default) { _  in
            self.downloadImage(self.hit.largeImageURL)
        }
        let cancelAction = UIAlertAction(title: "Cansel", style: .destructive)
        alert.addAction(previewSizeAction)
        alert.addAction(webFormatAction)
        alert.addAction(largeSizeAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func downloadImage(_ urlSize: String) {
        networkManager.fetchImageFromUrl(urlSize) { result in
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
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    private func configureView() {
        networkManager.fetchImageFromUrl(hit.previewURL) { result in
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
        navigationController?.isNavigationBarHidden = true
        view.addSubview(topView)
        topView.textField.delegate = self
        view.backgroundColor = .white
        topView.translatesAutoresizingMaskIntoConstraints = false
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

//MARK: - Interactive Menu:

extension ImagePageViewController {
    
    func interactiveSortMenu(sortetBy: String? = nil) -> UIMenu {
        let downloadsAction = UIAction(title: SortByEnum.downloads.labelMenu, image: IconsEnum.downloadMenuImage) { action in
            self.arrayHits?.sort(by: { downloadOne, downloadTwo in
                downloadOne.downloads > downloadTwo.downloads
            })
            self.downView.smalCollectionView.scrollToItem(at: .init(item: 0, section: 0), at: .top, animated: true)
            self.sortType = .downloads
            self.topView.sortedButton.menu = self.interactiveSortMenu(sortetBy: action.title)
        }
        
        let likesAction = UIAction(title: SortByEnum.likes.labelMenu, image: IconsEnum.likesMenuImage) { action in
            self.arrayHits?.sort(by: { likesOne, likesTwo in
                likesOne.likes > likesTwo.likes
            })
            self.downView.smalCollectionView.scrollToItem(at: .init(item: 0, section: 0), at: .top, animated: true)
            self.sortType = .likes
            self.topView.sortedButton.menu = self.interactiveSortMenu(sortetBy: action.title)
        }
        
        let viewsAction = UIAction(title: SortByEnum.views.labelMenu, image: IconsEnum.viewMenuImage) { action in
            self.arrayHits?.sort(by: { viewsOne, viewsTwo in
                viewsOne.views > viewsTwo.views
            })
            self.sortType = .views
            self.downView.smalCollectionView.scrollToItem(at: .init(item: 0, section: 0), at: .top, animated: true)
            self.topView.sortedButton.menu = self.interactiveSortMenu(sortetBy: action.title)
        }
        
        let commentsAction = UIAction(title: SortByEnum.comments.labelMenu, image: IconsEnum.commentsMenuImage) { action in
            self.arrayHits?.sort(by: { commentsOne, commentsTwo in
                commentsOne.comments > commentsTwo.comments
            })
            self.downView.smalCollectionView.scrollToItem(at: .init(item: 0, section: 0), at: .top, animated: true)
            self.sortType = .comments
            self.topView.sortedButton.menu = self.interactiveSortMenu(sortetBy: action.title)
        }
        
        let menu = UIMenu(title: TitleEnum.titleMenu, image: UIImage(systemName: IconsEnum.menuImage), options: .singleSelection, children: [downloadsAction, likesAction, viewsAction, commentsAction])
        
        if let sortetBy = sortetBy {
            menu.children.forEach { action in
                guard let action = action as? UIAction else {return}
                if action.title == sortetBy {
                    action.state = .on
                    action.attributes = .destructive
                }
            }
        }
        return menu
    }
}
