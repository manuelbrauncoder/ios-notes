//
//  cameraView.swift
//  simple notes
//
//  Created by Manuel Braun on 12.11.24.
//
// This file provides functionality to access the camera and capture photos.

import SwiftUI
import PhotosUI

/// A SwiftUI wrapper for UIImagePickerController to enable camera access within a SwiftUI view.
/// This view allows users to capture a new photo and store it as a UIImage and Data format.
struct accessCameraView: UIViewControllerRepresentable {
    
    /// The captured image from the camera.
    @Binding var selectedImage: UIImage?
    
    /// The captured image data, used for storage or processing purposes.
    @Binding var imgData: Data?
    
    /// Manages the dismissal of the view.
    @Environment(\.presentationMode) var isPresented
    
    /// Creates and configures the UIImagePickerController with camera settings.
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    /// Updates the UIImagePickerController if necessary. Currently not used but required by protocol.
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) { }
    
    /// Creates a coordinator instance to handle image selection and view dismissal.
    func makeCoordinator() -> Coordinator {
        return Coordinator(picker: self)
    }
}

/// A coordinator that manages interactions with UIImagePickerController, including capturing and processing the image.
class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    /// A reference to the accessCameraView, enabling access to update selected image and data.
    var picker: accessCameraView
    
    /// Initializes the coordinator with a reference to the accessCameraView.
    init(picker: accessCameraView) {
        self.picker = picker
    }
    
    /// Called when the user has selected an image or taken a new photo.
    /// - Parameters:
    ///   - picker: The UIImagePickerController instance handling the capture.
    ///   - info: A dictionary containing the media data, including the captured image.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        self.picker.selectedImage = selectedImage
        
        // Convert the image to Data format for storage or further processing
        if let imageData = selectedImage.jpegData(compressionQuality: 0.8) {
            self.picker.imgData = imageData
        }
        
        // Dismiss the UIImagePickerController
        self.picker.isPresented.wrappedValue.dismiss()
    }
}
