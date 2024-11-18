//
//  addNoteView.swift
//  simple notes
//
//  Created by Manuel Braun on 09.11.24.
//
// This View is for adding new notes

import Foundation
import SwiftUI
import SwiftData
import PhotosUI

struct addNoteView: View {
    
    @Query private var folders: [Folder]
    @State private var selectedFolder: Folder?
    @State private var showAddFolderSheet = false
    
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
            let newNote = Note(title: title, note_text: note_text, created_at: Date(), favorite: false, notificationID: id, reminder: reminderDate, imgData: imgData, folder: selectedFolder)
            modelContext.insert(newNote)
            dismiss()
        } else {
            let newNote = Note(title: title, note_text: note_text, created_at: Date(), favorite: false, imgData: imgData, folder: selectedFolder)
            modelContext.insert(newNote)
            dismiss()
        }
        
    }
    
    var body: some View {
        
        NavigationView {
            Form {
                Section("Title") {
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
                
                Section("Note") {
                    TextEditor(text: $note_text)
                        .foregroundStyle(.secondary)
                        .frame(minHeight: 150)
                        .focused($inputActive)
                }
                Section("Folder") {
                    Button("Create new Folder") {
                        showAddFolderSheet = true
                    }
                    .sheet(isPresented: $showAddFolderSheet) {
                        addFolderView()
                    }
                    if !folders.isEmpty {
                        Picker("Choose a Folder", selection: $selectedFolder) {
                            ForEach(folders, id: \.self) {
                                Text($0.name).tag($0)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }
                Section("Reminder") {
                    Toggle("Reminder?", isOn: $setReminder)
                        .onChange(of: setReminder) {
                            requestNotificationPermission()
                        }
                    if setReminder {
                        DatePicker("Date", selection: $reminderDate)
                    }
                }
                
                Section("Image") {
                    
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
