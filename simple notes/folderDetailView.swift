//
//  folderDetailView.swift
//  simple notes
//
//  Created by Manuel Braun on 13.11.24.
//

import Foundation
import SwiftUI

struct folderDetailView: View {
    
    @Bindable var folder: Folder
    let folder_description_default = "No description available"
    @State private var showAddNoteSheet = false
    @State private var folderDescription = ""
    
    private func filteredNotes() -> [Note] {
        if folder.notes != nil {
            return folder.notes!.filter { $0.trashNote == false }
        } else {
            return []
        }
    }
    
    private func saveDescription() {
        folder.folder_description = folderDescription
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section("Description") {
                    if folder.folder_description == nil {
                        TextField("Add a description for this folder", text: $folderDescription)
                        Button("Save") {
                            saveDescription()
                        }
                        .disabled(folderDescription.isEmpty)
                    } else {
                        Text(folder.folder_description ?? folder_description_default)
                    }
                }
                
                Section("Notes") {
                    ForEach(filteredNotes()) { note in
                                NavigationLink(destination: noteDetailView(note: note)) {
                                    noteCard(note: note)
                        }
                    }
                }
            }
            .navigationTitle(folder.name)
            .navigationBarTitleDisplayMode(.inline)
            .overlay {
                if filteredNotes().isEmpty {
                    ContentUnavailableView {
                        Label("No notes in this Folder", systemImage: "note")
                    } description: {
                        Text("add a note by pressing the plus Button")
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showAddNoteSheet = true
                    }, label: {
                        Image(systemName: "square.and.pencil")
                    })
                    .sheet(isPresented: $showAddNoteSheet) {
                        addNoteView()
                    }
                }
            }
        }
    }
}


#Preview {
    @Previewable @State var folder = Folder(title: "Test Folder", notes: [Note(title: "Note 1", note_text: "Text 1", created_at: Date(), favorite: false)], folder_description: "This is my folder for testing awesome things!")
    folderDetailView(folder: folder)
}
