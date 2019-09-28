//
//  ImagePickerManager.swift
//  eKar
//
//  Created by Arya Menon K on 9/27/19.
//  Copyright © 2019 Arya. All rights reserved.
//

import UIKit

class ImagePickerManager: NSObject {
    
    enum `Type` {
        case `default`
        case clearImage
    }
    
    var picker = UIImagePickerController()
    var alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
    var viewController: UIViewController?
    var pickImageCallback : ((UIImage) -> ())?
    var clearImageCallback : (() -> Void)?
    var type =  `Type`.default
    
    convenience init(type: `Type` =  .default) {
        self.init()
        self.type = type
    }
    
    func pickImage(_ viewController: UIViewController, _ callback: @escaping ((UIImage) -> ())) -> ImagePickerManager {
        // set callback for image selction success
        pickImageCallback = callback
        
        // viewController used to present
        self.viewController = viewController
        
        switch type {
        case .default:
            // only camera and gallery
            addDefaultPhotoPickerOptions()
            
        case .clearImage :
            addDefaultPhotoPickerOptions()
            
            //add clear image button
            addActionButton(title: "Clear Image") { [weak self] _  in
                self?.clearImageCallback?()
            }
        }
        
        // add cancel button.
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        
        // Add the actions
        picker.delegate = self
        alert.popoverPresentationController?.sourceView = self.viewController?.view
        viewController.present(alert, animated: true, completion: nil)
        return self
    }
    
    private func addDefaultPhotoPickerOptions() {
        
        // to add camera
        addActionButton(title: "Camera") {  _ in
            self.openCamera()
        }
        
        // to add gallery
        addActionButton(title: "Gallery") {  _  in
            self.openGallery()
        }
    }
    
    private func addActionButton(title: String,actionCallback: ((UIAlertAction) -> Void)?) {
        // add actions in action sheet
        let action = UIAlertAction(title: title, style: .default) { actionButton in
            actionCallback?(actionButton)
        }
        alert.addAction(action)
    }
    
    private func openCamera() {
        alert.dismiss(animated: true, completion: nil)
        
        // check if camera is available
        guard (UIImagePickerController .isSourceTypeAvailable(.camera)) else {
            let alertWarning = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alertWarning.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            viewController?.present(alertWarning, animated: false, completion: nil)
            return
        }
        
        // display the camera
        picker.sourceType = .camera
        self.viewController?.present(picker, animated: true, completion: nil)
    }
    
    private func openGallery() {
        // display the gallery
        alert.dismiss(animated: true, completion: nil)
        picker.sourceType = .photoLibrary
        self.viewController?.present(picker, animated: true, completion: nil)
    }
}

extension ImagePickerManager: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else { return }
        
        // calback for image selection
        pickImageCallback?(image)
    }
}
