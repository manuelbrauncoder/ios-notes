//
//  addFolderView.swift
//  simple notes
//
//  Created by Manuel Braun on 13.11.24.
//

import Foundation
import SwiftUI
import SwiftData


struct addFolderView: View {
    
    @State private var name = ""
    @State private var description = ""
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @FocusState var inputActive: Bool
    
    private func saveFolder() {
        let newFolder = Folder(title: name, folder_description: description)
        modelContext.insert(newFolder)
        dismiss()
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Name") {
                    TextField("Folder Name", text: $name)
                }
                Section("Description") {
                    TextField("Description", text: $description)
                }
            }
            .navigationBarTitle("Add Folder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveFolder()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}


#Preview {
    addFolderView()
        .modelContainer(for: [Folder.self], inMemory: true)
}
