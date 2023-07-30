//
//  StartViewController + UIMenu.swift
//  ImagesSearch
//
//  Created by Olya Sabadina on 2023-07-30.
//

import UIKit

extension StartViewController {
    
    func createMenu(typePicture: String? = nil) -> UIMenu {
        let allAction = UIAction(title: TypeEnum.all.labelButton, image: TitlesAndImagesEnum.menuAllImages, attributes: .keepsMenuPresented) { action in
            self.typeImageFind = .all
            self.imagesSearchButton.menu = self.createMenu(typePicture: action.title)
        }
        let photoAction = UIAction(title: TypeEnum.photo.labelButton, image: TitlesAndImagesEnum.menuPhotoImage) { action in
            self.typeImageFind = .photo
            self.imagesSearchButton.menu = self.createMenu(typePicture: action.title)
        }
        let illustrationAction = UIAction(title: TypeEnum.illustration.labelButton, image: TitlesAndImagesEnum.menuIllustrationImage) { action in
            self.typeImageFind = .illustration
            self.imagesSearchButton.menu = self.createMenu(typePicture: action.title)
        }
        let vectorAction = UIAction(title: TypeEnum.vectorSVG.labelButton, image: TitlesAndImagesEnum.menuVectorImage) { action in
            self.typeImageFind = .vectorSVG
            self.imagesSearchButton.menu = self.createMenu(typePicture: action.title)
        }
        
        let menu = UIMenu(title: TitlesAndImagesEnum.menuTitle, image: nil, options: .singleSelection, children: [allAction, photoAction, illustrationAction, vectorAction])
        
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
