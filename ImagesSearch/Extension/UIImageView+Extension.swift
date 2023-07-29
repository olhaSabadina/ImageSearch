//
//  UIImageView+Extension.swift
//  ImagesSearch
//
//  Created by Olya Sabadina on 2023-07-28.
//

import UIKit

extension UIImageView {
    
    func downloadImage(fromLink link: String) {
        guard let url = URL(string: link) else {
            print(NetworkErrors.badURL)
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print(NetworkErrors.invalidData)
                return
            }
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200,
                  let image = UIImage(data: data)
            else {
                print(NetworkErrors.responseStatusCodeError)
                return
            }
            
            DispatchQueue.main.async {[weak self] in
                self?.image = image
            }
        }.resume()
    }
}
