//
//  CustomImagePicker.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 25.01.2022.
//

import UIKit

protocol CustomImagePickerDelegate: AnyObject {
    func imagePicker(_ picker: CustomImagePicker, didSelect image: UIImage?)
}

class CustomImagePicker: NSObject {
    
    private var pickerController: UIImagePickerController?
    private weak var pickerDelegate: CustomImagePickerDelegate?
    
    convenience init(sourceType: UIImagePickerController.SourceType, delegate: CustomImagePickerDelegate) {
        self.init()
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else { return }
        pickerDelegate = delegate
        pickerController = UIImagePickerController()
        pickerController?.delegate = self
        pickerController?.allowsEditing = true
        pickerController?.mediaTypes = ["public.image"]
        pickerController?.sourceType = sourceType
    }
    
    func presentOn(controller: UIViewController) {
        guard let pickerController = pickerController else {
            return
        }
        controller.present(pickerController, animated: true, completion: nil)
    }
}

extension CustomImagePicker: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        pickerDelegate?.imagePicker(self, didSelect: nil)
        pickerController?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            pickerDelegate?.imagePicker(self, didSelect: nil)
            return
        }
        
        pickerDelegate?.imagePicker(self, didSelect: image)
        pickerController?.dismiss(animated: true, completion: nil)
    }
}

extension CustomImagePicker: UINavigationControllerDelegate { }
