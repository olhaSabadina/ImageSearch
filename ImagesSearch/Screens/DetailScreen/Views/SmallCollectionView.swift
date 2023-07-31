//
//  SmallCollectionView.swift
//  ImagesSearch
//
//  Created by Olya Sabadina on 2023-07-27.
//

import UIKit

class SmallCollectionView: UIView {
    
    var smalCollectionView: UICollectionView! = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        smalCollectionView.frame = self.bounds
    }
    
//MARK: - Private func:
    
    private func setupView() {
        backgroundColor = .white
    }
    
    private func setCollectionView() {
        smalCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        addSubview(smalCollectionView)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let fractional1: CGFloat = 0.6
        let fractional2: CGFloat = 0.4
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            let item1 = CompositionalLayout.createItem(width: .fractionalWidth(fractional1), height: .fractionalHeight(1), spacing: 2)
            let item2 = CompositionalLayout.createItem(width: .fractionalWidth(fractional2), height: .fractionalHeight(1), spacing: 2)
            let item3 = CompositionalLayout.createItem(width: .fractionalWidth(1), height: .fractionalHeight(1), spacing: 2)
            
            let group1 = CompositionalLayout.createGroupeItems(aligment: .horizontal, width: .fractionalWidth(1), height: .fractionalHeight(0.5), items: [item1,item2])
            let group2 = CompositionalLayout.createGroupeCount(aligment: .vertical, width: .fractionalWidth(fractional2), height: .fractionalHeight(0.5), item: item3, count: 2)
            let group3 = CompositionalLayout.createGroupeItems(aligment: .horizontal, width: .fractionalWidth(1), height: .fractionalHeight(0.5), items: [group2,item1])
            
            let mainGroup = CompositionalLayout.createGroupeItems(aligment: .vertical, width: .fractionalWidth(1), height: .fractionalHeight(1), items: [group1,group3])
            
            let section = NSCollectionLayoutSection(group: mainGroup)
            
            return section
        }
        return layout
    }
}
