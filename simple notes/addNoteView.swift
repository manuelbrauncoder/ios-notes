//
//  addNoteView.swift
//  simple notes
//
//  Created by Manuel Braun on 09.11.24.
//

import Foundation
import SwiftUI
import SwiftData
import PhotosUI

struct addNoteView: View {
    
    @State private var title = ""
    @State private var note_text = ""
    @State private var reminderDate = Date.now
    @State private var setReminder = false
    
    @State private var selectedImage: UIImage? // for showing preview
    @State private var imgData: Data? // for saving in swift data
    @State private var imgItem: PhotosPickerItem?
    
    @FocusState var inputActive: Bool
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    private func saveNote() {
        if setReminder {
            let id = UUID().uuidString
            scheduleNotification(reminderDate: reminderDate, reminderID: id, title: title, body: note_text)
            let newNote = Note(title: title, note_text: note_text, created_at: Date(), favorite: false, notificationID: id, reminder: reminderDate, imgData: imgData)
            modelContext.insert(newNote)
            dismiss()
        } else {
            let newNote = Note(title: title, note_text: note_text, created_at: Date(), favorite: false, imgData: imgData)
            modelContext.insert(newNote)
            dismiss()
        }
        
    }
    
    var body: some View {
        
        NavigationView {
            Form {
                Section {
                    Text("Title:")
                    TextField("", text: $title)
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
                        
                        
                }
                
                Section {
                    Text("Note:")
                    TextEditor(text: $note_text)
                        .foregroundStyle(.secondary)
                        .frame(minHeight: 150)
                        .focused($inputActive)
                }
                Section {
                    Toggle("Reminder?", isOn: $setReminder)
                        .onChange(of: setReminder) {
                            requestNotificationPermission()
                        }
                    if setReminder {
                        DatePicker("Date", selection: $reminderDate)
                    }
                }
                
                Section {
                    
                    photoPickerView(imgData: $imgData, selectedImage: $selectedImage)
                    openCameraButton(selectedImage: $selectedImage, imgData: $imgData)
                    
                    if let selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                    }
                }
            }
            .navigationBarTitle("Add Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveNote()
                    }
                    .disabled(title.isEmpty || note_text.isEmpty)
                }
            }
        }
    }
}

#Preview {
    addNoteView()
        .modelContainer(for: [Note.self], inMemory: true)
}
