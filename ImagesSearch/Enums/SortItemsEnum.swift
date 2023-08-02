//
//  SortItemsEnum.swift
//  ImagesSearch
//
//  Created by Olya Sabadina on 2023-07-24.
//

import Foundation
import UIKit

enum SortByEnum {
    case none
    case downloads
    case views
    case likes
    case comments
    
    var labelMenu: String {
        switch self {
        case .downloads:
            return "Downloads"
        case .views:
            return "Views"
        case .likes:
            return "Likes"
        case .comments:
            return "Comments"
        case .none:
            return "Cancel"
        }
    }
    
    var reactoinImage: UIImage? {
        switch self {
        case .downloads:
            return ImagesEnum.downloadMenuImage
        case .views:
            return ImagesEnum.viewMenuImage
        case .likes:
            return ImagesEnum.likesMenuImage
        case .comments:
            return ImagesEnum.commentsMenuImage
        case .none:
            return ImagesEnum.cancelMenuImage
        }
    }
    
    func returnValue(_ hit: Hit?) -> Int {
         guard let hit = hit else {return 0}
       
        switch self {
        case .none:
            return hit.id // нужно вернуть всесь массив без сортировки
        case .downloads:
            return hit.downloads
        case .views:
            return hit.views
        case .likes:
            return hit.likes
        case .comments:
            return hit.comments
        }
    }
}
