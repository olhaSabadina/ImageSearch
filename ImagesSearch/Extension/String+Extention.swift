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
}
