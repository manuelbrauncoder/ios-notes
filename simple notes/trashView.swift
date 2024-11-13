//
//  trashView.swift
//  simple notes
//
//  Created by Manuel Braun on 13.11.24.
//
// The Trash Notes View
//
// ToDo: Restore Note, Delete Note permanently

import Foundation
import SwiftUI
import SwiftData


struct trashView: View {
    
    @Query(filter: #Predicate<Note> { note in
        note.trashNote == true
    }) var notes: [Note]
    
    @Environment(\.modelContext) var modelContext
    @State private var showDeleteAlert = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(notes) { note in
                    
                    Section {
                        Text(note.title)
                            .font(.title3)
                        Text(truncatedText(note.note_text, limit: 30))
                            .foregroundStyle(.secondary)
                        
                        Button {
                            note.trashNote = false
                        } label: {
                            Label("Restore", systemImage: "arrow.2.circlepath.circle")
                        }
                        
                        Button {
                            showDeleteAlert = true
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        .alert("Delete Note permanently?", isPresented: $showDeleteAlert) {
                            Button("Delete", role: .destructive) {
                                modelContext.delete(note)
                            }
                            Button("Cancel", role: .cancel){
                                showDeleteAlert = false
                            }
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
    trashView()
        .modelContainer(for: [Note.self], inMemory: true)
}
