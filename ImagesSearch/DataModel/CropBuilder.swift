//
//  CropBuilder.swift
//  ImagesSearch
//
//  Created by Yura Sabadin on 17.08.2023.
//
import CropViewController
import Foundation
import UIKit

class CropBuilder {
    
    static func showCropVC(_ image: UIImage) ->  CropViewController {
        
        let vc = CropViewController(croppingStyle: .default, image: image)
        vc.aspectRatioPreset = .presetSquare
        vc.aspectRatioLockEnabled = true
        vc.toolbarPosition = .bottom
        vc.doneButtonTitle = "Done"
        vc.cancelButtonTitle = "Cancel"
        vc.doneButtonColor = .systemOrange
        vc.cancelButtonColor = .systemRed
        return vc
    }
}
