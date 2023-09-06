//
//  ViewController.swift
//  ImagesSearch
//
//  Created by Olya Sabadina on 2023-06-14.
//
import CropViewController
import UIKit

class PictureSearchViewController: UIViewController {
    
    let titleLabel = UILabel()
    let downLabel = UILabel()
    let imagesTypeButton = UIButton()
    var searchButton = UIButton()
    var selectFotoFromGalleryButton = UIButton()
    let searchTextField = UITextField()
    let backgroundImageView = UIImageView()
    var menuTypeImage: MenuBuilder?
    var imageType: ImageType = .all {
        didSet {
            imagesTypeButton.setTitle(imageType.rawValue.capitalized, for: .normal)
        }
    }
    
// MARK: - Life cycle:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setConstraints()
    }
    
//MARK: - @objc func:
    
    @objc func openFindPictureVC() {
        let findPictureVC = ListPictureViewController()
        let findWord = searchTextField.text ?? ""
        findPictureVC.findImageByType = imageType
        findPictureVC.findPicturesByWord(findWord, imageType)
        searchTextField.text = nil
        navigationController?.pushViewController(findPictureVC, animated: true)
    }
    
    @objc func openPickerController() {
        let pickerImage = UIImagePickerController()
        pickerImage.sourceType = .photoLibrary
        pickerImage.delegate = self
        present(pickerImage, animated: true)
        
        
    }
}
//MARK: - TextFieldDelegate:

extension PictureSearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        openFindPictureVC()
        view.endEditing(true)
        return true
    }
    
}//MARK: - TextFieldDelegate:

extension PictureSearchViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        let cropVC = CropBuilder.createCropVC(image)
        cropVC.delegate = self
        picker.dismiss(animated: true)
        navigationController?.pushViewController(cropVC, animated: true)
    }
}
    
//MARK: - CropViewControllerDelegate:
extension PictureSearchViewController: CropViewControllerDelegate {
    
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        navigationController?.popViewController(animated: true)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {

        let cropAlbum = CustomAlbum(name: TitleConstants.albumName)
        cropAlbum.save(image: image) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.presentAlertWithTitle(title: TitleConstants.saveToGallary, message: "Folder named: \(TitleConstants.albumName)", options: TitleConstants.Ok, styleActionArray: [.default], alertStyle: .alert, completion: nil)
                case .failure(let err):
                    self.presentAlertWithTitle(title: "Sorry", message: err.localizedDescription, options: TitleConstants.Ok, styleActionArray: [.default], alertStyle: .alert, completion: nil)
                }
            }
        }
        navigationController?.popViewController(animated: true)
    }
}



