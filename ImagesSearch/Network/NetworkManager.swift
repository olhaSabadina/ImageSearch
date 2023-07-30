//
//  NetworkFetchManager.swift
//  ImagesSearch
//
//  Created by Olya Sabadina on 2023-06-18.
//

import Foundation
import UIKit

struct NetworkManager {
    
    func fetchData(findPictures: String, imageType: TypeEnum , completionhandler: @escaping (Result<ImagesData?, Error>)->Void) {
        guard let url = URL(string: "https://pixabay.com/api/?key=37479171-8736bcdb016edb77d2e073ccc&image_type=\(imageType.rawValue)&q=\(findPictures)")
        else {
            completionhandler(.failure(NetworkErrors.badURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil, let data = data
            else {
                completionhandler(.failure(NetworkErrors.invalidData))
                return
            }
            
            if let response = response as? HTTPURLResponse,
               !(200...299).contains(response.statusCode) {
                completionhandler(.failure(NetworkErrors.responseStatusCodeError))
            }
            
            let imagesModel = self.parseJSON(data: data)
            completionhandler(.success(imagesModel))
        }.resume()
    }
    
    func fetchImageFromUrl(_ url: String, completion: @escaping (Result<UIImage, Error>)->Void) {
        
        guard let url = URL(string: url) else {completion(.failure(NetworkErrors.badURLtoImage)); return}
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {completion(.failure(NetworkErrors.invalidDataImage))
                return}
            
            if let imageFromData = UIImage(data: data) {
                completion(.success(imageFromData))
            }
        }.resume()
    }
    
//    func downloadImage(fromLink link: String, completion: @escaping (UIImage?)->()) {
//
//        guard let url = URL(string: link) else {
//            print(NetworkErrors.badURL)
//            return completion(nil)
//        }
//
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard let data = data, error == nil else {
//                print(NetworkErrors.invalidData)
//                return completion(nil)
//            }
//            guard let response = response as? HTTPURLResponse,
//                  response.statusCode == 200,
//                  let image = UIImage(data: data)
//            else {
//                print(NetworkErrors.responseStatusCodeError)
//                return completion(nil)
//            }
//            return completion(image)
//        }.resume()
//    }
    
    private func parseJSON(data: Data) -> ImagesData? {
        let decoder = JSONDecoder()
        do{
            let imageData = try decoder.decode(ImagesData.self, from: data)
            return imageData
            
        } catch {
            print(NetworkErrors.errorParsing)
        }
        return nil
    }
}





