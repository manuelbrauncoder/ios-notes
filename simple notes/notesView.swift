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

struct notesView: View {
    
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
                Section {
                    ForEach(folders) { folder in
                        NavigationLink(destination: folderDetailView(folder: folder)) {
                            HStack {
                                Image(systemName: "folder")
                                Text(folder.name)
                            }
                            .padding(5)
                        }
                    }
                }
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
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showAddNoteSheet = true
                    }, label: {
                        Image(systemName: "square.and.pencil")
                    })
                    .sheet(isPresented: $showAddNoteSheet) {
                        addNoteView()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showAddFolderSheet = true
                    }, label: {
                        Image(systemName: "folder.badge.plus")
                    })
                    .sheet(isPresented: $showAddFolderSheet) {
                        addFolderView()
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    filterMenu(showOnlyFavs: $showOnlyFavs, sortByTitle: $sortByTitle)
                }
            }
        }
    }
}

#Preview {
    notesView()
        .modelContainer(for: [Note.self, Folder.self], inMemory: true)
}
