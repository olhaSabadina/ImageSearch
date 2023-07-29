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
            return ""
        }
    }
    
    var reactoinImage: UIImage? {
        switch self {
        case .downloads:
            return UIImage(systemName: "arrow.down.circle")
        case .views:
            return UIImage(systemName: "eye")
        case .likes:
            return UIImage(systemName: "hand.thumbsup")
        case .comments:
            return UIImage(systemName: "ellipsis.message.fill")
        case .none:
            return nil
        }
    }
    
    
    func returnNumbers(_ hit: Hit?) -> Int {
         guard let hit = hit else {return 0}
        switch self {
        case .none:
            return 0
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
