//
//  photoPickerView.swift
//  simple notes
//
//  Created by Manuel Braun on 12.11.24.
//
// This file is for the PhotoPicker

import Foundation
import SwiftUI
import PhotosUI

struct photoPickerView: View {
    
    @State private var imgItem: PhotosPickerItem?
    @Binding var imgData: Data?
    @Binding var selectedImage: UIImage?
    
    var body: some View {
        PhotosPicker(selection: $imgItem, matching: .images) {
            HStack {
                Image(systemName: "photo")
                Text("Choose image")
            }
        }
            .onChange(of: imgItem) {
        Task {
            if let loadedData = try? await imgItem?.loadTransferable(type: Data.self) {
                imgData = loadedData
                selectedImage = UIImage(data: loadedData)
                } else {
                    print("loading image data failed")
                }
            }
        }
    }
}
