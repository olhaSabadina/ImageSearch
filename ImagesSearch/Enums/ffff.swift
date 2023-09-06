//
//  ffff.swift
//  ImagesSearch
//
//  Created by Yura Sabadin on 23.08.2023.
//

import Foundation

/*
 
 CropViewController
 
 
 open var myView: UIView?
 
 
 
 fileprivate func setUpCropController() {
    
    if #available(iOS 13.0, *) {
        view.backgroundColor = .systemBackground
    } else {
        view.backgroundColor = .white
    }
    toCropViewController.cropView.backgroundColor = .white
    modalPresentationStyle = .fullScreen
    addChild(toCropViewController)
    transitioningDelegate = (toCropViewController as! UIViewControllerTransitioningDelegate)
    toCropViewController.delegate = self
    toCropViewController.didMove(toParent: self)
}

 open override func viewDidLayoutSubviews() {
     super.viewDidLayoutSubviews()
     toCropViewController.view.frame = CGRect(x: 0, y: 100, width: view.bounds.width, height: view.bounds.height - 100)
     toCropViewController.viewDidLayoutSubviews()
     myView?.frame = CGRect(x: 0, y: 20, width: view.bounds.width, height: 80)
 }


 open override func viewWillAppear(_ animated: Bool) {
     super.viewWillAppear(animated)
     
     // Defer adding the view until we're about to be presented
     if toCropViewController.view.superview == nil, let myView = myView {
         view.addSubview(toCropViewController.view)
         view.addSubview(myView)
     }
 }

*/
