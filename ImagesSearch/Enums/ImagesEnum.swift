//
//  ConstantEnum.swift
//  ImagesSearch
//
//  Created by Olya Sabadina on 2023-07-28.
//

import Foundation
import UIKit

enum ImagesEnum {
    
    static let magnifyingglass  = UIImage(systemName: "magnifyingglass")
    static let sortedImage = UIImage(systemName: "slider.horizontal.3")
    
    //Menu Images
    static let menuImage = "slider.horizontal.2.square.on.square"
    static let downloadMenuImage = UIImage(systemName:"arrow.down.circle")
    static let likesMenuImage = UIImage(systemName: "hand.thumbsup")
    static let viewMenuImage = UIImage(systemName: "eye")
    static let commentsMenuImage = UIImage(systemName: "ellipsis.message.fill")
    static let cancelMenuImage = UIImage(systemName: "clear")
    static let closeButtonImage = UIImage(systemName:"xmark")
    
    //Icon For TopView
    static let backButtonImage = UIImage(named: "P")
    
    //Images for StartViewController
    static let backgroundImage  = UIImage(named: "backgroundImage")
    static let separatorImage   = UIImage(systemName: "poweron")
    static let chevronDownImage = UIImage(systemName: "chevron.down")

    static let menuAllImages    = UIImage(systemName: "photo.stack.fill")
    static let menuPhotoImage   = UIImage(systemName: "photo.fill")
    static let menuIllustrationImage = UIImage(systemName: "circle.hexagonpath.fill")
    static let menuVectorImage       = UIImage(systemName: "arrow.up.forward")
    
    //ImageCell
    static let shareButton = UIImage(named: "share")
    
    //LargeImageView (DetailScreen
    static let zoomButtonImage = UIImage(systemName: "plus.magnifyingglass")
}
