//
//  notesView.swift
//  simple notes
//
//  Created by Manuel Braun on 09.11.24.
//
// the list with all notes, showing
// the noteCard of each note
//
// The notes Tab in Tab View

import Foundation
import SwiftUI
import SwiftData

struct AllNotesView: View {
    
    @Query(filter: #Predicate<Note> { note in
        note.trashNote == false
    }) var notes: [Note]
    
    @Query var folders: [Folder]
    
    @Environment(\.modelContext) var modelContext
    
    @State private var showAddNoteSheet = false
    @State private var showAddFolderSheet = false
    @State private var showOnlyFavs = false
    @State private var sortByTitle = false
    @State private var searchTerm = ""
    
    var body: some View {
        NavigationStack {
            List {
                notesList(showOnlyFavs: $showOnlyFavs, sortByTitle: $sortByTitle)
            }
            .overlay {
                if notes.isEmpty {
                    ContentUnavailableView {
                        Label("No Notes added", systemImage: "note")
                    } description: {
                        Text("Press the plus to add a new note")
                    }
                }
            }
            .navigationTitle("Notes")
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    BottomToolBarButtons()
                }
            }
        }
    }
}

#Preview {
    AllNotesView()
        .modelContainer(for: [Note.self, Folder.self], inMemory: true)
}
