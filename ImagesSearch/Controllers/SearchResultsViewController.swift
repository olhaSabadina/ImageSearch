//
//  SearchResultsViewController.swift
//  ImagesSearch
//
//  Created by Olya Sabadina on 2023-06-18.
//

import UIKit

class SearchResultsViewController: UIViewController {
    
    private let networkFetchManager = NetworkFetchManager()
    
    var imageArrayFromNet: [Hit]?
    var imagesArrayForPreview: [String] = []
    
    private let imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentMode = .center
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setImageCollectionView()
        fetchDataFromNet("nature")
        setConstraints()
    }
    
    private func fetchDataFromNet(_ sertchRequest: String) {
        networkFetchManager.fetchData(picturesCategory: sertchRequest) { data, error in
            guard let data = data else {
                print("no data to request")
                return
            }
            self.transformDataToImagesModelAndRecordImagesArrayFromNet(data)
            self.addImagesToImagesArrayForCollectonView()
        }
    }
    
    private func transformDataToImagesModelAndRecordImagesArrayFromNet(_ jsonData: Data?) {
        networkFetchManager.parseData(jsonData) { model in
            self.imageArrayFromNet = model?.imagesArray
        }
        print(imageArrayFromNet?.count ?? "", "пришел массив с интернета")
    }
    
    private func addImagesToImagesArrayForCollectonView() {
        guard let fullImagesArray = imageArrayFromNet else {return}
        guard fullImagesArray.count != 0 else {
            print("fullImagesArray.count = Пусто \(fullImagesArray.count) ")
            return}
        var tempArray = [String]()
        fullImagesArray.forEach { item in
            tempArray.append(item.previewURL)
        }
        imagesArrayForPreview = tempArray
        print("imagesArrayForPreview.count" , tempArray.count)
    }
    
    private func setUpView() {
        view.backgroundColor = .white
        title = "SearchResults"
    }
    
    private func setImageCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 60, height: 60)
        layout.scrollDirection = .vertical
        
        imageCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        imageCollectionView.backgroundColor = .white
        imageCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.imageCellIdentifier)
        
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        view.addSubview(imageCollectionView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            imageCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            imageCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
    }
    
}

extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20 // imagesArrayForPreview.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.imageCellIdentifier, for: indexPath) as? ImageCollectionViewCell else {return UICollectionViewCell()}
//        cell = imagesArrayForPreview
        cell.backgroundColor = .blue
        //        cell.setLabelForStart(for: indexPath.row)
        return cell
    }
    
    
}
