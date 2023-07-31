//
//  ImageViewController.swift
//  ImagesSearch
//
//  Created by Olya Sabadina on 2023-07-28.
//

import UIKit

class ImageViewController: UIViewController {

    private enum ScaleMode {
        case min
        case max
    }
    
    private var zoomType: ScaleMode = .min
    private let scrollView = UIScrollView()
    private let closeButton = UIButton()
    private let imageView = UIImageView()
    private var imageTopConstraint: NSLayoutConstraint!
    private var imageLeftConstraint: NSLayoutConstraint!
    private var imageRightConstraint: NSLayoutConstraint!
    private var imageDownConstraint: NSLayoutConstraint!
    
//MARK: - Init:
    
    init(_ image: UIImage) {
        self.imageView.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - Life Cycle:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setConstraints()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateMinZoomScaleForSize(zoomType)
    }
    
//MARK: -  @objc func:
    
    @objc func closeImageVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func switchTypeZoom() {
        zoomType = zoomType == .min ? .max : .min
        updateMinZoomScaleForSize(zoomType)
    }
    
//MARK: -  private func:
    
    private func setupView() {
        view.backgroundColor = .black
        setupImageView()
        setupScroll()
        setupCloseButton()
    }
    
    private func setupScroll() {
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
    }
    
    private func setupImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(imageView)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(switchTypeZoom))
        tapGesture.numberOfTapsRequired = 2
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
    }
    
    private func setupCloseButton() {
        view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setImage(ImagesEnum.closeButtonImage, for: .normal)
        closeButton.setBorderLayer(backgroundColor: .lightGray.withAlphaComponent(0.8), borderColor: .black, borderWidth: 1, cornerRadius: 15, tintColor: .white)
        closeButton.addTarget(self, action: #selector(closeImageVC), for: .touchUpInside)
    }
    
    private func updateConstraintsForSize(_ size: CGSize) {
        let yOffset = max(0, (size.height - imageView.frame.height) / 2)
        imageTopConstraint.constant = yOffset
        imageDownConstraint.constant = yOffset
        
        let xOffset = max(0, (size.width - imageView.frame.width) / 2)
        imageLeftConstraint.constant = xOffset
        imageRightConstraint.constant = xOffset
        
        view.layoutIfNeeded()
    }
    
    private func updateMinZoomScaleForSize( _ zoomType: ScaleMode) {
        let size = view.bounds.size

        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minScale
        
        switch zoomType {
        case .min:
            UIView.animate(withDuration: 0.4) {
                self.scrollView.zoomScale = minScale
            }
        case .max:
            UIView.animate(withDuration: 0.4) {
                self.scrollView.zoomScale = 1
            }
        }
    }
    
    private func setConstraints() {
        imageTopConstraint = imageView.topAnchor.constraint(equalTo: scrollView.topAnchor)
        imageLeftConstraint = imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor)
        imageRightConstraint = imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
        imageDownConstraint = imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            imageTopConstraint,
            imageDownConstraint,
            imageLeftConstraint,
            imageRightConstraint,
            
            closeButton.widthAnchor.constraint(equalTo: closeButton.heightAnchor),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
        ])
    }
}

//MARK: - UIScrollViewDelegate

extension ImageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraintsForSize(view.bounds.size)
    }
}
