//
//  searchNotesView.swift
//  simple notes
//
//  Created by Manuel Braun on 10.11.24.
//
// The search Tab in Tab View

import Foundation
import SwiftUI
import SwiftData


struct searchNotesView: View {
    
    @Query var notes: [Note]
    @State private var searchTerm = ""
    
    private var filteredNotes: [Note] {
        if searchTerm.isEmpty {
            return []
        } else {
            return notes.filter { note in
                note.trashNote == false && ( note.title.lowercased().contains(searchTerm.lowercased()) ||
                                             note.note_text.lowercased().contains(searchTerm.lowercased()))
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredNotes) { note in
                    NavigationLink(value: note) {
                        noteCard(note: note)
                    }
                    
                }
            }
            .navigationDestination(for: Note.self) {
                note in
                noteDetailView(note: note)
            }
            .navigationTitle("Search Notes")
            .overlay {
                if filteredNotes.isEmpty {
                    ContentUnavailableView.search
                }
            }
        }
        .searchable(text: $searchTerm)
    }
}

#Preview {
    searchNotesView()
}
