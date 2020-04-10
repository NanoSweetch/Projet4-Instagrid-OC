//
//  ImagePicker.swift
//  Instagrid
//
//  Created by Maxime DUTOUR on 21/03/2020.
//  Copyright © 2020 Macbook pro. All rights reserved.
//

import UIKit

 extension ViewGridController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        // MARK: - UIImagePickerController
        
        /// Function image picker
        /// - Parameters:
        ///   - picker: Call the UIImagePickerController
        ///   - info: Retrieves information from the selected image
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                if let selectedImageView = selectedImageView {
                    selectedImageView.image = image
                }
            }
            self.dismiss(animated: true, completion: nil)
            changeAppearanceButton()
        }
    }
