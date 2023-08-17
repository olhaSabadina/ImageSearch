//
//  NetworkFetchManager.swift
//  ImagesSearch
//
//  Created by Olya Sabadina on 2023-06-18.
//

import Foundation
import UIKit

struct NetworkManager {
    
    func fetchData(findPictures: String, imageType: ImageType , completionhandler: @escaping (Result<ImagesData?, Error>)->Void) {
        let urlString = imageType.fullPath + findPictures
        guard let url = URL(string: urlString)
        else {
            completionhandler(.failure(ImageSearchErrors.badURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil, let data = data
            else {
                completionhandler(.failure(ImageSearchErrors.invalidData))
                return
            }
            
            if let response = response as? HTTPURLResponse,
               !(200...299).contains(response.statusCode) {
                completionhandler(.failure(ImageSearchErrors.responseStatusCodeError))
            }
            
            let imagesModel = self.parseJSON(data: data)
            completionhandler(.success(imagesModel))
        }.resume()
    }
    
    func downloadImageFromUrl(_ url: String, completion: @escaping (Result<UIImage, Error>)->Void) {
        
        guard let url = URL(string: url) else {completion(.failure(ImageSearchErrors.badURLtoImage)); return}
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {completion(.failure(ImageSearchErrors.invalidDataImage))
                return}
            
            if let imageFromData = UIImage(data: data) {
                completion(.success(imageFromData))
            }
        }.resume()
    }
    
    private func parseJSON(data: Data) -> ImagesData? {
        let decoder = JSONDecoder()
        do{
            let imageData = try decoder.decode(ImagesData.self, from: data)
            return imageData
            
        } catch {
            print(ImageSearchErrors.errorParsing)
        }
        return nil
    }
}





