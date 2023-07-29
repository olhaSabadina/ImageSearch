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
    var hits: [Hit]
    var related: [String] {
        guard  hits.count != 0 && hits[0].tags != "" else {return []}
        var relatedArray = hits[0].tags.components(separatedBy: ",")
        relatedArray.insert("Related", at: 0)
        return relatedArray
    }
}

// MARK: - Hit
struct Hit: Codable {
    let id: Int
    let pageURL: String
    let type: TypeEnum
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

enum TypeEnum: String, Codable {
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
}
