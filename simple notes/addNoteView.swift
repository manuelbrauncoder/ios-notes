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
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    
    
    private func saveNote() {
        let newNote = Note(title: title, note_text: note_text, created_at: Date(), favorite: false)
        modelContext.insert(newNote)
        dismiss()
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
