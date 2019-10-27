//
//  ImagePicker.swift
//  Loqal
//
//  Created by Sreejith Ajithkumar on 16/01/18.
//  Copyright © 2018 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

protocol ImagePickerPresentable: class {
    func showImagePicker(isEditable: Bool)
    func selectedImage(image: UIImage?)
}

extension ImagePickerPresentable where Self: UIViewController {
    fileprivate func pickerControllerActionFor(for type: UIImagePickerController.SourceType, title: String, isEditable: Bool) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            let pickerController           = UIImagePickerController()
            pickerController.delegate      = ImagePickerHelper.shared
            pickerController.sourceType    = type
            pickerController.allowsEditing = isEditable
            self.present(pickerController, animated: true)
        }
    }
    
    func showImagePicker(isEditable: Bool) {
        ImagePickerHelper.shared.delegate = self
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if let action = self.pickerControllerActionFor(for: .camera, title: "Take photo", isEditable: isEditable) {
            optionMenu.addAction(action)
        }
        if let action = self.pickerControllerActionFor(for: .photoLibrary, title: "Photo Library", isEditable: isEditable) {
            optionMenu.addAction(action)
        }
        
        optionMenu.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(optionMenu, animated: true)
    }
}


class ImagePickerHelper: NSObject {
    
    weak var delegate: ImagePickerPresentable?
    
    static let shared = ImagePickerHelper()
    
    func picker(picker: UIImagePickerController, selectedImage image: UIImage?) {
        picker.dismiss(animated: true, completion: nil)
        
        let fixedImage = image?.fixOrientation()
        
        self.delegate?.selectedImage(image: fixedImage)
        self.delegate = nil
    }
}

extension ImagePickerHelper: UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.picker(picker: picker, selectedImage: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[picker.allowsEditing ? .editedImage : .originalImage] as? UIImage else {
            return self.picker(picker: picker, selectedImage: nil)
        }
        
        self.picker(picker: picker, selectedImage: image)
    }
    
    @objc func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.picker(picker: picker, selectedImage: image)
    }
}

extension ImagePickerHelper: UINavigationControllerDelegate {
    
}

extension UIImage {
    class func getColoredRectImageWith(color: CGColor, andSize size: CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let graphicsContext = UIGraphicsGetCurrentContext()
        graphicsContext?.setFillColor(color)
        let rectangle = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        graphicsContext?.fill(rectangle)
        let rectangleImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return rectangleImage!
    }
    
    func fixOrientation() -> UIImage? {
        if (self.imageOrientation == .up) {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        self.draw(in: rect)
        
        let fixedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return fixedImage
    }
    
}
