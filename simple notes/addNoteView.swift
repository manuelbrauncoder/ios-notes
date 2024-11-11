//
//  addNoteView.swift
//  simple notes
//
//  Created by Manuel Braun on 09.11.24.
//

import Foundation
import SwiftUI
import SwiftData


struct addNoteView: View {
    
    @State private var title = ""
    @State private var note_text = ""
    @State private var reminderDate = Date.now
    @State private var setReminder = false
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    private func saveNote() {
        if setReminder {
            let id = UUID().uuidString
            scheduleNotification(reminderDate: reminderDate, reminderID: id, title: title, body: note_text)
            let newNote = Note(title: title, note_text: note_text, created_at: Date(), favorite: false, notificationID: id, reminder: reminderDate)
            modelContext.insert(newNote)
            dismiss()
        } else {
            let newNote = Note(title: title, note_text: note_text, created_at: Date(), favorite: false)
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
                        
                }
                Section {
                    Text("Note:")
                    TextEditor(text: $note_text)
                        .foregroundStyle(.secondary)
                        .frame(minHeight: 150)
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
