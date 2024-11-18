//
//  folderDetailView.swift
//  simple notes
//
//  Created by Manuel Braun on 13.11.24.
//

import Foundation
import SwiftUI
import SwiftData

struct FolderDetailView: View {
    
    @Bindable var folder: Folder
    let folder_description_default = "No description available"
    @State private var showAddNoteSheet = false
    @State private var folderDescription = ""
    @State private var editFolder = false
    @State private var folderName = ""
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var showDeleteFolderAlert = false
    
    private func filteredNotes() -> [Note] {
        if folder.notes != nil {
            return folder.notes!.filter { $0.trashNote == false }
        } else {
            return []
        }
    }
    
    private func saveEditedFolder() {
        folder.folder_description = folderDescription
        folder.name = folderName
    }
    
    private func prepareEditMode() {
        folderName = folder.name
        folderDescription = folder.folder_description ?? ""
        editFolder = true
    }
    
    private func deleteFolder() {
        if folder.notes != nil {
            for note in folder.notes! {
                note.folder = nil
            }
            modelContext.delete(folder)
            dismiss()
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                if editFolder {
                    TextField("Foldername", text: $folder.name)
                    TextField("Description", text: $folderDescription)
                    
                } else {
                    if folder.folder_description != "" {
                    Section("Description") {
                            Text(folder.folder_description ?? folder_description_default)
                        }
                    }
                    Section("Notes") {
                        ForEach(filteredNotes()) { note in
                            NavigationLink(destination: NoteDetailView(note: note)) {
                                NoteCard(note: note)
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button(role: .destructive, action: {
                                    if note.notificationID != nil {
                                        removeNotification(id: note.notificationID!)
                                    }
                                    note.trashNote = true
                                }, label: {
                                    Label("Delete", systemImage: "trash.fill")
                                })
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button(action: {
                                    note.favorite.toggle()
                                }) {
                                    Label("Favorite", systemImage: "bookmark.fill")
                                }
                            }
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
            
            .alert("Delete Folder", isPresented: $showDeleteFolderAlert) {
                Button("Delete", role: .destructive) {
                    deleteFolder()
                }
                Button("Cancel", role: .cancel){
                    showDeleteFolderAlert = false
                }
            }
        
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    if editFolder {
                        Button(action: {
                            saveEditedFolder()
                            editFolder = false
                        }, label: {
                            Text("Save")
                                .foregroundStyle(.yellow)
                        })
                        .disabled(folderName.isEmpty || folderDescription.isEmpty)
                    } else {
                        Menu(content: {
                            Button(action: {
                                prepareEditMode()
                            }, label: {
                                Text("Edit Folder")
                                Image(systemName: "pencil")
                            })
                            Button(action: {
                                showDeleteFolderAlert = true
                            }, label: {
                                Text("Delete Folder")
                                Image(systemName: "trash")
                            })
                        }, label: {
                            Image(systemName: "ellipsis.circle")
                                .foregroundStyle(.yellow)
                        })
                    }
                    
                }
                ToolbarItemGroup(placement: .bottomBar) {
                    BottomToolBarButtons()
                }
            }
        }
    }
}


#Preview {
    @Previewable @State var folder = Folder(title: "Test Folder", notes: [Note(title: "Note 1", note_text: "Text 1", created_at: Date(), favorite: false)], folder_description: "This is my folder for testing awesome things!")
    FolderDetailView(folder: folder)
}
