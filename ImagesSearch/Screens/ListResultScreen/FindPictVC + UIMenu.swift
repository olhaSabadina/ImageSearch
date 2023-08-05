//
//  FindPictVC + UIMenu.swift
//  ImagesSearch
//
//  Created by Olya Sabadina on 2023-07-30.
//

import UIKit

extension FindPictureViewController {
    
    func interactiveSortMenu(sortetBy: String? = nil) -> UIMenu {
        let downloadsAction = UIAction(title: SortModel.downloads.titleSortModelCases, image: ImageConstants.download) { action in
            self.imagesArray?.sort(by: { downloadOne, downloadTwo in
                downloadOne.downloads > downloadTwo.downloads
            })
            self.sortType = .downloads
            self.topView.sortedButton.menu = self.interactiveSortMenu(sortetBy: action.title)
        }
        let likesAction = UIAction(title: SortModel.likes.titleSortModelCases, image: ImageConstants.likes) { action in
            self.imagesArray?.sort(by: { likesOne, likesTwo in
                likesOne.likes > likesTwo.likes
            })
            self.sortType = .likes
            self.topView.sortedButton.menu = self.interactiveSortMenu(sortetBy: action.title)
        }
        let viewsAction = UIAction(title: SortModel.views.titleSortModelCases, image: ImageConstants.view) { action in
            self.imagesArray?.sort(by: { viewsOne, viewsTwo in
                viewsOne.views > viewsTwo.views
            })
            self.sortType = .views
            self.topView.sortedButton.menu = self.interactiveSortMenu(sortetBy: action.title)
        }
        let commentsAction = UIAction(title: SortModel.comments.titleSortModelCases, image: ImageConstants.comments) { action in
            self.imagesArray?.sort(by: { commentsOne, commentsTwo in
                commentsOne.comments > commentsTwo.comments
            })
            self.sortType = .comments
            self.topView.sortedButton.menu = self.interactiveSortMenu(sortetBy: action.title)
        }
        
        let canсelAction = UIAction(title: SortModel.none.titleSortModelCases, image: ImageConstants.cancel) { action in
            self.imagesArray?.shuffle()
            self.sortType = .none
            self.topView.sortedButton.menu = self.interactiveSortMenu(sortetBy: action.title)
        }
        
        let menu = UIMenu(title: TitleConstants.titleMenu, image: ImageConstants.sorted, options: .singleSelection, children: [downloadsAction, likesAction, viewsAction, commentsAction, canсelAction])
        
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
