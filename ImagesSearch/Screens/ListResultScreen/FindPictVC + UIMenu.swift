//
//  FindPictVC + UIMenu.swift
//  ImagesSearch
//
//  Created by Olya Sabadina on 2023-07-30.
//

import UIKit

extension FindPictureViewController {
    
    func interactiveSortMenu(sortetBy: String? = nil) -> UIMenu {
        let downloadsAction = UIAction(title: SortByEnum.downloads.labelMenu, image: ImagesEnum.downloadMenuImage) { action in
            self.hitsArray?.sort(by: { downloadOne, downloadTwo in
                downloadOne.downloads > downloadTwo.downloads
            })
            self.sortType = .downloads
            self.topView.sortedButton.menu = self.interactiveSortMenu(sortetBy: action.title)
        }
        let likesAction = UIAction(title: SortByEnum.likes.labelMenu, image: ImagesEnum.likesMenuImage) { action in
            self.hitsArray?.sort(by: { likesOne, likesTwo in
                likesOne.likes > likesTwo.likes
            })
            self.sortType = .likes
            self.topView.sortedButton.menu = self.interactiveSortMenu(sortetBy: action.title)
        }
        let viewsAction = UIAction(title: SortByEnum.views.labelMenu, image: ImagesEnum.viewMenuImage) { action in
            self.hitsArray?.sort(by: { viewsOne, viewsTwo in
                viewsOne.views > viewsTwo.views
            })
            self.sortType = .views
            self.topView.sortedButton.menu = self.interactiveSortMenu(sortetBy: action.title)
        }
        let commentsAction = UIAction(title: SortByEnum.comments.labelMenu, image: ImagesEnum.commentsMenuImage) { action in
            self.hitsArray?.sort(by: { commentsOne, commentsTwo in
                commentsOne.comments > commentsTwo.comments
            })
            self.sortType = .comments
            self.topView.sortedButton.menu = self.interactiveSortMenu(sortetBy: action.title)
        }
        
        let menu = UIMenu(title: TitleEnum.titleMenu, image: ImagesEnum.sortedImage, options: .singleSelection, children: [downloadsAction, likesAction, viewsAction, commentsAction])
        
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
