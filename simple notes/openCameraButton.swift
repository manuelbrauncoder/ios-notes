//
//  openCameraButton.swift
//  simple notes
//
//  Created by Manuel Braun on 12.11.24.
//

import Foundation
import SwiftUI


struct openCameraButton: View {
    
    @State private var showCamera: Bool = false
    @Binding var selectedImage: UIImage?
    @Binding var imgData: Data?
    
    var body: some View {
        Button {
            self.showCamera.toggle()
        } label: {
            HStack {
                Image(systemName: "camera")
                Text("Open Camera")
            }
        }
        .fullScreenCover(isPresented: $showCamera) {
            accessCameraView(selectedImage: self.$selectedImage, imgData: self.$imgData)
                .background(.black)
        }
    }
}