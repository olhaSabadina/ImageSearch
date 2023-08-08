//
//  URLConstans.swift
//  ImagesSearch
//
//  Created by Olga Sabadina on 07.08.2023.
//

import Foundation

enum UrlBuilder {
    
    private var baseURL: String {
        return "https://pixabay.com/api/?key=37479171-8736bcdb016edb77d2e073ccc"
    }
    
    case all
    case photo
    case illustration
    case vectorAI
    case vectorSVG
    
    var fullPath: String {
        var endpoint:String
        switch self {
        case .all:
            endpoint = "&image_type=all"
        case .photo:
            endpoint = "&image_type=photo"
        case .illustration:
            endpoint = "&image_type=illustration"
        case .vectorAI:
            endpoint = "&image_type=vectorAI"
        case .vectorSVG:
            endpoint = "&image_type=vector/svg"
        }
        
        return baseURL + endpoint + "&q="
    }
}


