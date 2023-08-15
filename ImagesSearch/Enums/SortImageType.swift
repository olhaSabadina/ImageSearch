//
//  SortModel.swift
//  ImagesSearch
//
//  Created by Olya Sabadina on 2023-07-24.
//

import Foundation
import UIKit

enum SortImageType {
    case none
    case downloads
    case views
    case likes
    case comments
    
    var titleSortModelCases: String {
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
    
    var imageSortModelCases: UIImage? {
        switch self {
        case .downloads:
            return ImageConstants.download
        case .views:
            return ImageConstants.view
        case .likes:
            return ImageConstants.likes
        case .comments:
            return ImageConstants.comments
        case .none:
            return ImageConstants.cancel
        }
    }
    
    func returnValue(_ hit: ImageDescription?) -> Int {
         guard let hit = hit else {return 0}
       
        switch self {
        case .none:
            return hit.id
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
