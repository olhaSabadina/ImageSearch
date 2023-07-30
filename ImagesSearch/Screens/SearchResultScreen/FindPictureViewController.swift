//
//  FindPictureViewController.swift
//  ImagesSearch
//
//  Created by Olya Sabadina on 2023-06-20.
//

import UIKit

class FindPictureViewController: UIViewController {
    
    var typeImageFind: TypeEnum = .all
    private let topView = TopView()
    private let imageCell = ImageCell()
    private let networkManager = NetworkFetchManager()
    private var sortType: SortByEnum = .none
    private var collectionView : UICollectionView! = nil
    private var imagesDescription: ImagesData? = nil
    private var hitsArray: [Hit]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        setView()
        addTapGestureToHideKeyboard()
        addTargetForButtons()
        setConstraint()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
//MARK: - @objc func:
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func pushLink(_ sender: UIButton ) {
        let hitUrl = hitsArray?[sender.tag].largeImageURL ?? ""
        shareURL(hitUrl)
    }
    
    @objc func backToStartVC() {
        navigationController?.popViewController(animated: true)
    }
    
//MARK: - @objc private func:
    
    private func addTapGestureToHideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func findPicturesByWord(_ findPictures: String, _ findImageType: TypeEnum) {
        let requestString = findPictures.replaceSpaceToPlus()
        networkManager.fetchData(findPictures: requestString, imageType: typeImageFind) { result in
            switch result {
            case .success(let imgData):
                DispatchQueue.main.async {
                    self.imagesDescription = imgData
                    self.hitsArray = imgData?.hits
                }
            case .failure(let errror):
                print(errror)
                self.alertNotData()
            }
        }
    }
    
    private func alertNotData() {
        let alert = UIAlertController(title: "Sorry", message: "Your request is invalid", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.topView.textField.text = ""
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    private func addTargetForButtons() {
        topView.backButton.addTarget(self, action: #selector(backToStartVC), for: .touchUpInside)
        topView.sortedButton.menu = interactiveSortMenu()
    }
    
    private func interactiveSortMenu(sortetBy: String? = nil) -> UIMenu {
        let downloadsAction = UIAction(title: SortByEnum.downloads.labelMenu, image: IconsEnum.downloadMenuImage) { action in
            self.hitsArray?.sort(by: { downloadOne, downloadTwo in
                downloadOne.downloads > downloadTwo.downloads
            })
            self.sortType = .downloads
            self.topView.sortedButton.menu = self.interactiveSortMenu(sortetBy: action.title)
        }
        let likesAction = UIAction(title: SortByEnum.likes.labelMenu, image: IconsEnum.likesMenuImage) { action in
            self.hitsArray?.sort(by: { likesOne, likesTwo in
                likesOne.likes > likesTwo.likes
            })
            self.sortType = .likes
            self.topView.sortedButton.menu = self.interactiveSortMenu(sortetBy: action.title)
        }
        let viewsAction = UIAction(title: SortByEnum.views.labelMenu, image: IconsEnum.viewMenuImage) { action in
            self.hitsArray?.sort(by: { viewsOne, viewsTwo in
                viewsOne.views > viewsTwo.views
            })
            self.sortType = .views
            self.topView.sortedButton.menu = self.interactiveSortMenu(sortetBy: action.title)
        }
        let commentsAction = UIAction(title: SortByEnum.comments.labelMenu, image: IconsEnum.commentsMenuImage) { action in
            self.hitsArray?.sort(by: { commentsOne, commentsTwo in
                commentsOne.comments > commentsTwo.comments
            })
            self.sortType = .comments
            self.topView.sortedButton.menu = self.interactiveSortMenu(sortetBy: action.title)
        }
        
        let menu = UIMenu(title: TitleEnum.titleMenu, image: IconsEnum.sortedImage, options: .singleSelection, children: [downloadsAction, likesAction, viewsAction, commentsAction])
        
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
    
// MARK: - Set view elemets:
    
    private func setView() {
        navigationController?.isNavigationBarHidden = true
        view.addSubview(topView)
        view.backgroundColor = .white
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.textField.delegate = self
    }
    
    private func setCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(RelatedCell.self, forCellWithReuseIdentifier: RelatedCell.identCell)
        collectionView.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.headerIdentifier )
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identCell)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
//  MARK: - CollectionViewLayout:
    
    private func createLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            if sectionIndex == 0 {
                return self.createRelatedSection()
            } else {
                return self.createImageSection()
            }
        }
        return layout
    }
    
    private func createRelatedSection() -> NSCollectionLayoutSection {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        sectionHeader.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 0)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(80), heightDimension:.absolute(30))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(80), heightDimension: .absolute(30))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [sectionHeader]
    
        return section
    }
    
    private func createImageSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/3))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: 8, leading: 20, bottom: 8, trailing: 20)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets.top = 15
        
        return section
    }
}

//  MARK: - CollectionViewDelegate,DataSours:

extension FindPictureViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return imagesDescription?.related.count ?? 1
        }
        return hitsArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RelatedCell.identCell, for: indexPath) as? RelatedCell else {return UICollectionViewCell()}
            let textLabel = imagesDescription?.related[indexPath.item] ?? ""
            cell.setTextLabel(indexPath.item, textLabel: textLabel)
            return cell
        } else if indexPath.section == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identCell, for: indexPath) as? ImageCell else {return UICollectionViewCell()}
            cell.sortType = sortType
            cell.hit = hitsArray?[indexPath.item]
            cell.shareButton.tag = indexPath.item
            cell.shareButton.addTarget(self, action: #selector(pushLink(_: )), for: .touchUpInside)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row != 0 {
            
            let cell = collectionView.cellForItem(at: indexPath) as? RelatedCell
            let textLabel = cell?.labelText.text ?? ""
            topView.textField.text = textLabel
            findPicturesByWord(textLabel, typeImageFind)
            
        } else if indexPath.section == 1 {
            let cell = collectionView.cellForItem(at: indexPath) as? ImageCell
            
            guard let someHit = cell?.hit else {return}
            let imagePageVC = ImagePageViewController(someHit)
            imagePageVC.arrayHits = hitsArray
            navigationController?.pushViewController(imagePageVC, animated: true)

            imagePageVC.completion = {[weak self] searchWord in
                guard let self = self else {return}
                self.topView.textField.text = searchWord
                self.findPicturesByWord(searchWord, self.typeImageFind)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if kind == UICollectionView.elementKindSectionHeader && indexPath.section == 0 {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCollectionReusableView.headerIdentifier, for: indexPath) as? HeaderCollectionReusableView else {return UICollectionReusableView()}
            let totalImage = imagesDescription?.total ?? 0
            header.configTotalImageLabel(totalImage)
            return header
        }
        return UICollectionReusableView()
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

//MARK: - TextFieldDelegate:

extension FindPictureViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let findPicturesString = textField.text ?? ""
        findPicturesByWord(findPicturesString, typeImageFind)
        view.endEditing(true)
        return true
    }
}
