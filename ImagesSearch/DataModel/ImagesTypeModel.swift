//
//  ImagesTypeModel.swift
//  ImagesSearch
//
//  Created by Olga Sabadina on 08.08.2023.
//

import Foundation

struct ImagesTypeModel {
    
    var imagesArray: [ImageDescription]?
    var sortImageType: SortImageType
    
    init(_ imagesArray: [ImageDescription]? = nil, _ sortImageType: SortImageType) {
        self.imagesArray = imagesArray
        self.sortImageType = sortImageType
    }
}
