//
//  StartSearchVC+SortingMenu.swift
//  ImagesSearch
//
//  Created by Olya Sabadina on 2023-07-30.
//

import UIKit

extension StartSaerchViewController {
    
    func createMenu(typePicture: String? = nil) -> UIMenu {
        let allAction = UIAction(title: ImageType.all.labelButton, image: ImageConstants.allImages, attributes: .keepsMenuPresented) { action in
            self.findImageByType = .all
            self.imagesSearchButton.menu = self.createMenu(typePicture: action.title)
        }
        let photoAction = UIAction(title: ImageType.photo.labelButton, image: ImageConstants.photo) { action in
            self.findImageByType = .photo
            self.imagesSearchButton.menu = self.createMenu(typePicture: action.title)
        }
        let illustrationAction = UIAction(title: ImageType.illustration.labelButton, image: ImageConstants.illustration) { action in
            self.findImageByType = .illustration
            self.imagesSearchButton.menu = self.createMenu(typePicture: action.title)
        }
        let vectorAction = UIAction(title: ImageType.vectorSVG.labelButton, image: ImageConstants.vector) { action in
            self.findImageByType = .vectorSVG
            self.imagesSearchButton.menu = self.createMenu(typePicture: action.title)
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
        return menu
    }
}
