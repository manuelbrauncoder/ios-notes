//
//  trashView.swift
//  simple notes
//
//  Created by Manuel Braun on 13.11.24.
//
// The Trash Notes View
//

import Foundation
import SwiftUI
import SwiftData


struct TrashView: View {
    
    @Query(filter: #Predicate<Note> { note in
        note.trashNote == true
    }) var notes: [Note]
    
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(notes) { note in
                    NoteCardTrash(note: note)
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive, action: {
                                modelContext.delete(note)
                            }) {
                                Label("Delete", systemImage: "trash")
                            }
                            
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(action: {
                                note.trashNote = false
                            }) {
                                Label("Restore", systemImage: "arrow.2.circlepath.circle")
                            }
                        }
                }
            }
            .overlay {
                if notes.isEmpty {
                    ContentUnavailableView {
                        Label("No Notes in Trash", systemImage: "trash")
                    } description: {
                        Text("")
                    }
                }
            }
            .navigationTitle("Trash")
        }
    }
}


#Preview {
    TrashView()
        .modelContainer(for: [Note.self], inMemory: true)
}
