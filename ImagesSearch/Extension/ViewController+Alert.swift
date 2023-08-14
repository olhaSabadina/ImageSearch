//
//  ViewController+Alert.swift
//  ImagesSearch
//
//  Created by Olga Sabadina on 12.08.2023.
//

import UIKit

extension UIViewController {

    func presentAlertWithTitle(title: String, message: String?, options: String...,styleActionArray: [UIAlertAction.Style?],alertStyle: UIAlertController.Style, completion: ((Int) -> Void)?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: alertStyle)
        
        for (index, option) in options.enumerated() {
            alertController.addAction(UIAlertAction.init(title: option, style: styleActionArray[index] ?? .default, handler: { (action) in
                completion?(index)
            }))
        }
        self.present(alertController, animated: true, completion: nil)
    }
}
