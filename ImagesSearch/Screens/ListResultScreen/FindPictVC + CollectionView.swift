//
//  FindPictVC + CollectionView.swift
//  ImagesSearch
//
//  Created by Olya Sabadina on 2023-07-30.
//

import UIKit

extension FindPictureViewController {
    
    func setCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(RelatedCell.self, forCellWithReuseIdentifier: RelatedCell.identCell)
        collectionView.register(HeaderCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionView.headerIdentifier )
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identCell)
        view.addSubview(collectionView)
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

        let item = CompositionalLayout.createItem(width: .estimated(80), height: .absolute(30), spacing: 0)
        
        let group = CompositionalLayout.createGroupeCount(aligment: .horizontal, width: .estimated(80), height: .absolute(30), item: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.interGroupSpacing = 8
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [sectionHeader]
    
        return section
    }
    
    private func createImageSection() -> NSCollectionLayoutSection {
        let item = CompositionalLayout.createItem(width: .fractionalWidth(1), height: .fractionalHeight(1), spacing: 0)
        
        let group = CompositionalLayout.createGroupeItems(aligment: .vertical, width: .fractionalWidth(1), height: .fractionalHeight((1/3)), items: [item])
        
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
        return imagesArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            //RelatedCell
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RelatedCell.identCell, for: indexPath) as? RelatedCell else {return UICollectionViewCell()}
            let textLabel = imagesDescription?.related[indexPath.item] ?? ""
            cell.setTextLabel(indexPath.item, textLabel: textLabel)
            return cell
            
        } else if indexPath.section == 1 {
            //ImageCell
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identCell, for: indexPath) as? ImageCell else {return UICollectionViewCell()}
            cell.sortType = sortType
            cell.imageToViewing = imagesArray?[indexPath.item]
            cell.shareButton.tag = indexPath.item
            cell.shareButton.addTarget(self, action: #selector(pushLink(_: )), for: .touchUpInside)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row != 0 {
            //RelatedCell
            let cell = collectionView.cellForItem(at: indexPath) as? RelatedCell
            let textLabel = cell?.labelText.text ?? ""
            topView.textField.text = textLabel
            findPicturesByWord(textLabel, findImageByType)
            
        } else if indexPath.section == 1 {
            //ImageCell
            let cell = collectionView.cellForItem(at: indexPath) as? ImageCell
            
            guard let someHit = cell?.imageToViewing else {return}
            let imagePageVC = ImagePageViewController(someHit)
            imagePageVC.arrayImages = imagesArray
            navigationController?.pushViewController(imagePageVC, animated: true)

            imagePageVC.completion = {[weak self] searchWord in
                guard let self = self else {return}
                self.topView.textField.text = searchWord
                self.findPicturesByWord(searchWord, self.findImageByType)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if kind == UICollectionView.elementKindSectionHeader && indexPath.section == 0 {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCollectionView.headerIdentifier, for: indexPath) as? HeaderCollectionView else {return UICollectionReusableView()}
            let totalImage = imagesDescription?.total ?? 0
            header.configTotalImageLabel(totalImage)
            return header
        }
        return UICollectionReusableView()
    }
}

