//
//  photoPickerView.swift
//  simple notes
//
//  Created by Manuel Braun on 12.11.24.
//

import Foundation
import SwiftUI
import PhotosUI
import UIKit


struct photoPickerView: View {
    
    @State private var imgItem: PhotosPickerItem?
    @Binding var img: Image?
    @Binding var imgData: Data?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    PhotosPicker("Select Image", selection: $imgItem, matching: .images)
                    img?
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 400)
                }
                .onChange(of: imgItem) {
                    Task {
                        if let loadedData = try? await imgItem?.loadTransferable(type: Data.self) {
                            imgData = loadedData

                        } else {
                            print("loading image data failed")
                        }
                        if let loadedImg = try? await imgItem?.loadTransferable(type: Image.self) {
                            img = loadedImg
                        } else {
                            print("loading image failed")
                        }
                    }
                }
            }
            .navigationTitle("Choose Image")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        img = nil
                        imgData = nil
                        dismiss()
                    }
                }
            }
        }
        
        
        
    }
}

#Preview {
    @Previewable @State var img: Image? = nil
    @Previewable @State var imgData: Data? = nil
    photoPickerView(img: $img, imgData: $imgData)
}
