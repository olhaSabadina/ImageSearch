//
//  PictureModel.swift
//  ImagesSearch
//
//  Created by Olya Sabadina on 2023-06-18.
//
import Foundation

// MARK: - ImagesData
struct ImagesData: Codable {
    let total, totalHits: Int
    var hits: [ImageDescription]
    var related: [String] {
        guard  hits.count != 0 && hits.first != nil else {return []}
        return hits[0].tags.transformRelatedToArray()
    }
}

// MARK: - ImageDescription
struct ImageDescription: Codable {
    let id: Int
    let pageURL: String
    let type: ImageType
    let tags: String
    let previewURL: String
    let previewWidth, previewHeight: Int
    let webformatURL: String
    let webformatWidth, webformatHeight: Int
    let largeImageURL: String
    let imageWidth, imageHeight, imageSize, views: Int
    let downloads, collections, likes, comments: Int
    let userID: Int
    let user: String
    let userImageURL: String
    
    enum CodingKeys: String, CodingKey {
        case id, pageURL, type, tags, previewURL, previewWidth, previewHeight, webformatURL, webformatWidth, webformatHeight, largeImageURL, imageWidth, imageHeight, imageSize, views, downloads, collections, likes, comments
        case userID = "user_id"
        case user, userImageURL
    }
}

enum ImageType: String, Codable {
    case all = "all"
    case photo = "photo"
    case illustration = "illustration"
    case vectorAI = "vectorAI"
    case vectorSVG = "vector/svg"
    
    var labelButton: String {
        switch self {
        case .all:
            return "All "
        case .photo:
            return "Photo "
        case .illustration:
            return "Illustration "
        case .vectorAI:
            return "Vector "
        case .vectorSVG:
            return "Vector SVG  "
        }
    }
    
    private var baseURL: String {
        return "https://pixabay.com/api/?key=37479171-8736bcdb016edb77d2e073ccc"
    }

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
