//
//  NetworkFetchManager.swift
//  ImagesSearch
//
//  Created by Olya Sabadina on 2023-06-18.
//

import Foundation

struct NetworkFetchManager {
    
    func fetchData(picturesCategory: String, completionhandler: @escaping (Data?, Error?)->(Void)) {
        
        guard let url = URL(string: "https://pixabay.com/api/?key=37479171-8736bcdb016edb77d2e073ccc&image_type=photo&category=\(picturesCategory)") else {
            completionhandler(nil, "Not valid URL" as? Error)
            return}
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard error == nil, let data = data else {
                completionhandler(nil, "not data" as? Error)
                return
            }
            if let response = response as? HTTPURLResponse,
               !(200...299).contains(response.statusCode) {
                completionhandler(nil, "status code error" as? Error)
            }
            
            completionhandler(data, nil)
            
        }
        task.resume()
    }
    
    func parseData(_ jsonData: Data?, completionhandler: @escaping (ImagesModel?)->()) {
        guard let data = jsonData else {
            completionhandler(nil)
            return
        }
        if let images = parseJSON(data: data) {
            completionhandler(images)
        }
    }
    
    private func parseJSON(data: Data) -> ImagesModel? {
        
        let decoder = JSONDecoder()
        
        do{
            let imageData = try decoder.decode(ImagesData.self, from: data)
            guard let finalImage = ImagesModel(imagesData: imageData) else { return nil
            }
            return finalImage
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
    
    
}
    
    
    
    
    
    
    
