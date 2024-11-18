//
//  noteDetailView.swift
//  simple notes
//
//  Created by Manuel Braun on 09.11.24.
//
// noteDetailView

import Foundation
import SwiftUI
import SwiftData

struct NoteDetailView: View {
    
    @Query var folders: [Folder]
    @Bindable var note: Note
    
    @State private var editNote = false
    @State private var alertRemoveReminder = false
    @State private var alertDeleteNote = false
    @State private var img: Image?
    @State private var selectedFolderName: String? = nil
    @State private var reminderDate = Date.now
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @FocusState var inputActive: Bool
    
    private func createReminder() {
        let id = UUID().uuidString
        scheduleNotification(reminderDate: reminderDate, reminderID: id, title: note.title, body: note.note_text)
        note.reminder = reminderDate
    }
    
    
    /// if there is an image in the Note,
    /// convert the imageData to an uiImage
    /// and display it
    private func loadImageFromData() {
        if let imgData = note.imgData, let uiImage = UIImage(data: imgData) {
            img = Image(uiImage: uiImage)
        } else {
            img = nil
        }
    }
    
    
    /// Remove the reminder of the note
    private func deleteReminder() {
        if note.reminder == nil { return }
        removeNotification(id: note.notificationID!)
        note.reminder = nil
        note.notificationID = nil
    }
    
    
    /// Remove the reminder
    /// Delete the note and
    /// go back
    private func deleteNote() {
        deleteReminder()
        note.trashNote = true
        dismiss()
    }
    
    /// if selectedFolderName is not an empty string:
    /// find the folder with selectedFolderName,
    /// push note into Folder
    /// push Folder into Note.folder
    /// save modelContext
    private func handleFolderSelection() {
        if selectedFolderName == "" {
            return
        } else {
            if let folder = folders.first(where: { $0.name == selectedFolderName }) {
                folder.notes?.append(note)
                note.folder = folder
                do {
                    try modelContext.save()
                } catch {
                    print("Error saving context: \(error.localizedDescription)")
                }
            }
        }
    }
    
    var body: some View {
        List {
            if editNote {
                Section {
                    Text("Title:")
                    TextField(note.title, text: $note.title)
                        .foregroundStyle(.secondary)
                        .focused($inputActive)
                    
                    Text("Note:")
                    TextEditor(text: $note.note_text)
                        .foregroundStyle(.secondary)
                        .frame(minHeight: 150)
                        .focused($inputActive)
                }
            } else {
                Section("Note") {
                    
                    Text(note.note_text)
                }
            }
            if let img = img {
                Section("Image") {
                    img
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 150)
                }
            }
            Section("Favorite") {
                Toggle("Favorite", isOn: $note.favorite)
                    .toggleStyle(SwitchToggleStyle(tint: .yellow))
            }
            Section("Folder") {
                if note.folder != nil {
                    Text("Folder: \(note.folder!.name)")
                } else {
                    Picker("Choose a Folder", selection: $selectedFolderName) {
                        Text("No Folder").tag("")
                        ForEach(folders, id: \.self) { folder in
                            Text(folder.name).tag(folder.name)
                        }
                    }
                    .onChange(of: selectedFolderName) {
                        handleFolderSelection()
                    }
                    .pickerStyle(.menu)
                }
            }
            Section("Created at") {
                HStack {
                    Image(systemName: "calendar")
                    Text("Created at: \(note.created_at.formatted())")
                }
                
            }
            Section("Reminder") {
                if note.reminder != nil {
                    HStack {
                        Image(systemName: "calendar.badge.clock")
                        Text("Reminder: \(note.reminder!.formatted())")
                        
                    }
                    Button("Remove Reminder") {
                        alertRemoveReminder = true
                    }
                    .alert("Remove Reminder?", isPresented: $alertRemoveReminder) {
                        Button("Remove", role: .destructive) {
                            deleteReminder()
                        }
                        Button("Cancel", role: .cancel){
                            alertRemoveReminder = false
                        }
                    }
                } else {
                    DatePicker("Date", selection: $reminderDate)
                    Button(action: {
                        createReminder()
                    }, label: {
                        Text("Save Reminder")
                    })
                }
            }
            
            
            
        }
        .alert("Move to Trash?", isPresented: $alertDeleteNote) {
            Button("Delete", role: .destructive) {
                deleteNote()
            }
            Button("Cancel", role: .cancel){
                alertDeleteNote = false
            }
        }
        .onAppear() {
            loadImageFromData()
        }
        .navigationTitle(note.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                if editNote {
                    Button(action: {
                        editNote = false
                    }, label: {
                        Text("Save")
                    })
                } else {
                    Menu(content: {
                        Button(action: {
                            editNote = true
                        }, label: {
                            Text("Edit")
                            Image(systemName: "pencil")
                        })
                        Button(action: {
                            alertDeleteNote = true
                        }, label: {
                            Text("Delete")
                            Image(systemName: "trash")
                        })
                    }, label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundStyle(.yellow)
                    })
                }
                
            }
        }
    }
}


#Preview {
    @Previewable @State var note = Note(title: "Test Title", note_text: "awesome very much important note text", created_at: Date(), favorite: false, notificationID: "1", reminder: Date())
    NoteDetailView(note: note)
}
