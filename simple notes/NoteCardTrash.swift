//
//  noteCardTrash.swift
//  simple notes
//
//  Created by Manuel Braun on 13.11.24.
//

import Foundation
import SwiftUI
import SwiftData


struct NoteCardTrash: View {
    
    @Bindable var note: Note
    @Environment(\.modelContext) var modelContext
    @State private var showDeleteAlert = false
    
    var body: some View {
        
        VStack {
            Text(note.title)
                .font(.title)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(truncatedText(note.note_text, limit: 20))
                .font(.callout)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(5)
        
        
        
        
    }
}

#Preview {
    @Previewable @State var note = Note(title: "trash card", note_text: "Create a good looking note card", created_at: Date(), favorite: false)
    NavigationStack {
        List {
            NoteCardTrash(note: note)
        }
    }
    
}
