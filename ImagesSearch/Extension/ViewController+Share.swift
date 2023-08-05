//
//  ViewController+Share.swift
//  ImagesSearch
//
//  Created by Olya Sabadina on 2023-08-05.
//

import UIKit

extension UIViewController {
    
    func shareFromURL(_ imageUrl: String, _ image: UIImage? = nil) {
        guard let url = URL(string: imageUrl) else {return}
        let activityItems: [Any] = image == nil ? [url] : [url, image ?? UIImage()]
        
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
}



