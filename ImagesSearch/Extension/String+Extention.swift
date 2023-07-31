//
//  String+Extention.swift
//  ImagesSearch
//
//  Created by Olya Sabadina on 2023-07-28.
//

import Foundation

extension String {
    func replaceSpaceToPlus() -> String {
        return self.replacingOccurrences(of: " ", with: "+")
    }
    
    func transformRelatedToArray() -> [String] {
        var relatedArray = self.components(separatedBy: ",")
        relatedArray.insert("Related", at: 0)
        return relatedArray
    }
}
