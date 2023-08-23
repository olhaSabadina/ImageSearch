//
//  CropBuilder.swift
//  ImagesSearch
//
//  Created by Olga Sabadina on 17.08.2023.
//
import CropViewController
import Foundation
import UIKit

class CropBuilder {
    
    static func createCropVC(_ image: UIImage) ->  CropViewController {
        
        let vc = CropViewController(croppingStyle: .default, image: image)
        vc.aspectRatioPreset = .preset16x9
        vc.cropView.alwaysShowCroppingGrid = true
        vc.cropView.gridOverlayHidden = false
        vc.cropView.translucencyAlwaysHidden = true
        vc.cropView.gridOverlayView.backgroundColor = .white.withAlphaComponent(0.3)
        vc.doneButtonTitle = "Save"
        vc.toolbarPosition = .bottom
        vc.cancelButtonTitle = "Cancel"
        vc.rotateButtonsHidden = true
        vc.resetButtonHidden = true
        vc.aspectRatioPickerButtonHidden = true
        vc.doneButtonColor = .white
        vc.cancelButtonColor = .black
        return vc
    }
}
