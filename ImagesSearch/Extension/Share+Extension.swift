//
//  Share+Extension.swift
//  ImagesSearch
//
//  Created by Olya Sabadina on 2023-07-26.
//

import UIKit
import Foundation

extension FindPictureViewController {
    
    func shareURL(_ imageUrl: String, _ image: UIImage? = nil) {
        guard let url = URL(string: imageUrl) else {return}
        let activityItems: [Any] = image == nil ? [url] : [url, image ?? UIImage()]
        
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
}
