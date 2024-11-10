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
    
    var body: some View {
        Form {
            Section {
                
                TextField(note.title, text: $note.title)
                TextEditor(text: $note.note_text)
            }
            
            Section {
                Toggle("Favorite", isOn: $note.favorite)
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
            }
            
            Section {
                Text("created at: \(note.created_at.formatted())")
            }
            
        }
        .navigationTitle(note.title)
    }
}


#Preview {
    @Previewable @State var note = Note(title: "test", note_text: "text", created_at: Date(), favorite: false)
    NavigationStack {
        noteDetailView(note: note)
    }
    
}
