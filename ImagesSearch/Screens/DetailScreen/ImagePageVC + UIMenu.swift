//
//  ImagePageVC + UIMenu.swift
//  ImagesSearch
//
//  Created by Olya Sabadina on 2023-07-30.
//

import UIKit

//MARK: - Interactive Menu:

extension ImagePageViewController {
    
    func interactiveSortMenu(sortetBy: String? = nil) -> UIMenu {
        let downloadsAction = UIAction(title: SortModel.downloads.titleSortModelCases, image: ImageConstants.download) { action in
            self.arrayImages?.sort(by: { downloadOne, downloadTwo in
                downloadOne.downloads > downloadTwo.downloads
            })
            self.downView.bottomCollectionView.scrollToItem(at: .init(item: 0, section: 0), at: .top, animated: true)
            self.sortType = .downloads
            self.topView.sortedButton.menu = self.interactiveSortMenu(sortetBy: action.title)
        }
        
        let likesAction = UIAction(title: SortModel.likes.titleSortModelCases, image: ImageConstants.likes) { action in
            self.arrayImages?.sort(by: { likesOne, likesTwo in
                likesOne.likes > likesTwo.likes
            })
            self.downView.bottomCollectionView.scrollToItem(at: .init(item: 0, section: 0), at: .top, animated: true)
            self.sortType = .likes
            self.topView.sortedButton.menu = self.interactiveSortMenu(sortetBy: action.title)
        }
        
        let viewsAction = UIAction(title: SortModel.views.titleSortModelCases, image: ImageConstants.view) { action in
            self.arrayImages?.sort(by: { viewsOne, viewsTwo in
                viewsOne.views > viewsTwo.views
            })
            self.sortType = .views
            self.downView.bottomCollectionView.scrollToItem(at: .init(item: 0, section: 0), at: .top, animated: true)
            self.topView.sortedButton.menu = self.interactiveSortMenu(sortetBy: action.title)
        }
        
        let commentsAction = UIAction(title: SortModel.comments.titleSortModelCases, image: ImageConstants.comments) { action in
            self.arrayImages?.sort(by: { commentsOne, commentsTwo in
                commentsOne.comments > commentsTwo.comments
            })
            self.downView.bottomCollectionView.scrollToItem(at: .init(item: 0, section: 0), at: .top, animated: true)
            self.sortType = .comments
            self.topView.sortedButton.menu = self.interactiveSortMenu(sortetBy: action.title)
        }
        
        let canсelAction = UIAction(title: SortModel.none.titleSortModelCases, image: ImageConstants.cancel) { action in
            self.arrayImages?.shuffle()
            self.downView.bottomCollectionView.scrollToItem(at: .init(item: 0, section: 0), at: .top, animated: true)
            self.sortType = .none
            self.topView.sortedButton.menu = self.interactiveSortMenu(sortetBy: action.title)
        }
        
        
        let menu = UIMenu(title: TitleConstants.titleMenu, image: UIImage(systemName: ImageConstants.menu), options: .singleSelection, children: [downloadsAction, likesAction, viewsAction, commentsAction, canсelAction])
        
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

