//
//  ImagesModel.swift
//  ImagesSearch
//
//  Created by Olya Sabadina on 2023-06-18.
//

import Foundation

struct ImagesModel {
    
    let tagsID: String
    let imagesArray: [Hit]
    
    init?(imagesData: ImagesData) {
        self.tagsID = imagesData.hits[3].tags
        self.imagesArray = imagesData.hits
        print("imagesData.hits[3].tags = \(tagsID)")
    }
    
}

