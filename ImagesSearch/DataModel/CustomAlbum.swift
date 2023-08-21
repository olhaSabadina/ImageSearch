//
//  CustomAlbum.swift
//  ImagesSearch
//
//  Created by Olga Sabadina on 17.08.2023.
//

import Photos
import UIKit

final class CustomAlbum: NSObject {
   
    var name: String
    
    private var assetCollection: PHAssetCollection?
    
    init(name: String) {
        self.name = name
        super.init()
        
        if let assetCollection = fetchAssetCollectionForAlbum() {
            self.assetCollection = assetCollection
            return
        }
    }
    
    private func checkAuthorizationWithHandler(completion: @escaping (Result<Bool, Error>) -> ()) {
        if PHPhotoLibrary.authorizationStatus() == .notDetermined {
            PHPhotoLibrary.requestAuthorization({ (status) in
                self.checkAuthorizationWithHandler(completion: completion)
            })
        }
        else if PHPhotoLibrary.authorizationStatus() == .authorized {
            self.createAlbumIfNeeded { (success) in
                completion(success)
            }
        }
        else {
            completion(.failure(ImageSearchErrors.notAutorized))
        }
    }
    
    private func createAlbumIfNeeded(completion: @escaping (Result<Bool, Error>) -> ()) {
        if let assetCollection = fetchAssetCollectionForAlbum() {
            // Album already exists
            self.assetCollection = assetCollection
            completion(.success(true))
        } else {
            PHPhotoLibrary.shared().performChanges({
                PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: self.name)   // create an asset collection with the album name
            }) { success, error in
                if let error = error {
                    completion(.failure(error))
                }
                if success {
                    self.assetCollection = self.fetchAssetCollectionForAlbum()
                    completion(.success(true))
                } else {
                    // Unable to create album
                    completion(.success(false))
                }
            }
        }
    }
    
    private func fetchAssetCollectionForAlbum() -> PHAssetCollection? {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", name)
        let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        
        if let _: AnyObject = collection.firstObject {
            return collection.firstObject
        }
        return nil
    }
    
    func save(image: UIImage, completion: @escaping (Result<Bool, Error>) -> ()) {
        self.checkAuthorizationWithHandler { (result) in
            switch result {
            case .success(let success):
                
                if success, let assetCollection = self.assetCollection {
                    PHPhotoLibrary.shared().performChanges({
                        let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
                        let assetPlaceHolder = assetChangeRequest.placeholderForCreatedAsset
                        if let albumChangeRequest = PHAssetCollectionChangeRequest(for: assetCollection) {
                            let enumeration: NSArray = [assetPlaceHolder ?? PHObjectPlaceholder()]
                            albumChangeRequest.addAssets(enumeration)
                        }
                    }, completionHandler: { (success, error) in
                        if let error = error {
                            print("Error writing to image library: \(error.localizedDescription)")
                            completion(.failure(error))
                            return
                        }
                        completion(.success(success))
                    })
                }
                
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }
}
