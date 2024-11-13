//
//  noteDetailView.swift
//  simple notes
//
//  Created by Manuel Braun on 09.11.24.
//
// noteDetailView

import Foundation
import SwiftUI


struct noteDetailView: View {
    
    @Bindable var note: Note
    @State private var editNote = false
    @State private var alertRemoveReminder = false
    @State private var alertDeleteNote = false
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var img: Image?
    @FocusState var inputActive: Bool
    
    
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
        modelContext.delete(note)
        dismiss()
    }
   
    var body: some View {
        Form {
            if editNote {
                Section {
                    Text("Title:")
                    TextField(note.title, text: $note.title)
                        .foregroundStyle(.secondary)
                        .focused($inputActive)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button("Done") {
                                    inputActive = false
                                }
                            }
                        }
                    Text("Note:")
                    TextEditor(text: $note.note_text)
                        .foregroundStyle(.secondary)
                        .frame(minHeight: 150)
                        .focused($inputActive)
                }
            } else {
                Section {
                    Text(note.title)
                        .font(.title)
                    Text(note.note_text)
                }
            }
            
            
                if let img = img {
                    Section {
                        img
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                    }
                
            }
            
            Section {
                Toggle("Favorite", isOn: $note.favorite)
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
            }
            
            if note.reminder != nil {
                Section {
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
                }
            }
            Section {
                HStack {
                    Image(systemName: "calendar")
                    Text("Created at: \(note.created_at.formatted())")
                }
                
            }
            
            Section {
                Button("Delete Note", role: .destructive) {
                    alertDeleteNote = true
                }
                .alert("Delete Note?", isPresented: $alertDeleteNote) {
                    Button("Delete", role: .destructive) {
                        deleteNote()
                    }
                    Button("Cancel", role: .cancel){
                        alertDeleteNote = false
                    }
                }
            }
        }
        .onAppear() {
            loadImageFromData()
        }
        .navigationTitle(note.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if editNote {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        editNote = false
                    }
                }
            } else {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        editNote = true
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
        }
    }
}


#Preview {
    @Previewable @State var note = Note(title: "Test Title", note_text: "awesome very much important note text", created_at: Date(), favorite: false, notificationID: "1", reminder: Date())
    noteDetailView(note: note)
}
