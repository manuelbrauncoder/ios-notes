//
//  noteDetailView.swift
//  simple notes
//
//  Created by Manuel Braun on 09.11.24.
//

import Foundation
import SwiftUI


struct noteDetailView: View {
    
    @Bindable var note: Note
    @State private var editNote = false
   
    
    var body: some View {
        Form {
            if editNote {
                Section {
                    Text("Title:")
                    TextField(note.title, text: $note.title)
                        .foregroundStyle(.secondary)
                    Text("Note:")
                    TextEditor(text: $note.note_text)
                        .foregroundStyle(.secondary)
                        .frame(minHeight: 150)
                }
            } else {
                Section {
                    Text(note.title)
                        .font(.title)
                    Text(note.note_text)
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
                    
                }
            }
            
            Section {
                Text("created at: \(note.created_at.formatted())")
            }
            
            
            
            
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
                    }label: {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
        }
    }
}


#Preview {
    @Previewable @State var note = Note(title: "Test Title", note_text: "awesome very much important note text", created_at: Date(), favorite: false)
    noteDetailView(note: note)
}
