//
//  NetworkErrorsEnum.swift
//  ImagesSearch
//
//  Created by Olya Sabadina on 2023-07-18.
//

import Foundation

public enum NetworkErrors: Error {
    case errorReturnCell
    case badURL
    case invalidData
    case badURLtoImage
    case invalidDataImage
    case errorParsing
    case errorDownloadImage
    case responseStatusCodeError
}
