//
//  MenuBuilder.swift
//  ImagesSearch
//
//  Created by Olga Sabadina on 08.08.2023.
//

import UIKit

final class MenuBuilder {
    
    //properties for PictureSearchViewController
    var imageType: ImageType = .all
    var imageTypeButton: UIButton = UIButton()
    var completionTypeImage: ((ImageType)->Void)?
    
    //properties for ListPictureVC and DetailPictureVC
    var sortType: SortImageType = .none
    var topView : TopView?
    var imageArray: [ImageDescription]?
    var completionArrayTypeSort: ((ImagesTypeModel)->())?
    
    //init for PictureSearchViewController
    init(_ imageType: ImageType, _ typeImgButton: UIButton) {
        self.imageType = imageType
        self.imageTypeButton = typeImgButton
    }
    
    //init for ListPictureVC and DetailPictureVC
    init(_ sortType: SortImageType, _ topView: TopView, _ imageArray: [ImageDescription]? = nil) {
        self.sortType = sortType
        self.topView = topView
        self.imageArray = imageArray
    }
    
    func typeImageMenu(typePicture: String? = nil) -> UIMenu {
        
        let allAction = UIAction(title: ImageType.all.labelButton, image: ImageConstants.allImages, attributes: .keepsMenuPresented) { action in
            self.imageType = .all
            self.imageTypeButton.menu = self.typeImageMenu(typePicture: action.title)
        }
        let photoAction = UIAction(title: ImageType.photo.labelButton, image: ImageConstants.photo) { action in
            self.imageType = .photo
            self.imageTypeButton.menu = self.typeImageMenu(typePicture: action.title)
        }
        let illustrationAction = UIAction(title: ImageType.illustration.labelButton, image: ImageConstants.illustration) { action in
            self.imageType = .illustration
            self.imageTypeButton.menu = self.typeImageMenu(typePicture: action.title)
        }
        let vectorAction = UIAction(title: ImageType.vectorSVG.labelButton, image: ImageConstants.vector) { action in
            self.imageType = .vectorSVG
            self.imageTypeButton.menu = self.typeImageMenu(typePicture: action.title)
        }
        
        let menu = UIMenu(title: TitleConstants.menuTitle, image: nil, options: .singleSelection, children: [allAction, photoAction, illustrationAction, vectorAction])
        
        if let typePicture = typePicture {
            menu.children.forEach { action in
                guard let action = action as? UIAction else {return}
                if action.title == typePicture {
                    action.state = .on
                    action.attributes = .destructive
                }
            }
        } else {
            let action = menu.children.first as? UIAction
            action?.state = .on
        }
        completionTypeImage?(imageType)
        return menu
    }
    
    func sortingImageMenu(sortetBy: String? = nil) -> UIMenu {
       
        let downloadsAction = UIAction(title: SortImageType.downloads.titleSortModelCases, image: ImageConstants.download) { action in
            self.imageArray?.sort { $0.downloads > $1.downloads }
            self.sortType = .downloads
            self.topView?.sortedButton.menu = self.sortingImageMenu(sortetBy: action.title)
        }
        
        let likesAction = UIAction(title: SortImageType.likes.titleSortModelCases, image: ImageConstants.likes) { action in
            self.imageArray?.sort { $0.likes > $1.likes }
            self.sortType = .likes
            self.topView?.sortedButton.menu = self.sortingImageMenu(sortetBy: action.title)
        }
        
        let viewsAction = UIAction(title: SortImageType.views.titleSortModelCases, image: ImageConstants.view) { action in
            self.imageArray?.sort { $0.views > $1.views }
            self.sortType = .views
            self.topView?.sortedButton.menu = self.sortingImageMenu(sortetBy: action.title)
        }
        
        let commentsAction = UIAction(title: SortImageType.comments.titleSortModelCases, image: ImageConstants.comments) { action in
            self.imageArray?.sort { $0.comments > $1.comments }
            self.sortType = .comments
            self.topView?.sortedButton.menu = self.sortingImageMenu(sortetBy: action.title)
        }
        
        let canсelAction = UIAction(title: SortImageType.none.titleSortModelCases, image: ImageConstants.cancel) { action in
            self.imageArray?.shuffle()
            self.sortType = .none
            self.topView?.sortedButton.menu = self.sortingImageMenu(sortetBy: action.title)
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
        completionArrayTypeSort?(ImagesTypeModel(imageArray, sortType))
        return menu
    }
}


