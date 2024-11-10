//
//  notesView.swift
//  simple notes
//
//  Created by Manuel Braun on 09.11.24.
//

import Foundation
import SwiftUI
import SwiftData


struct notesView: View {
    
    @Query var notes: [Note]
    @Environment(\.modelContext) var modelContext
    @State private var showSheet = false
    @State private var showOnlyFavs = false
    @State private var sortByTitle = false
    @State private var searchTerm = ""
    
    private var filteredNotes: [Note] {
           var result = notes
           if showOnlyFavs {
               result = result.filter { $0.favorite }
           }
           if sortByTitle {
               result = result.sorted { $0.title < $1.title }
           }
           return result
       }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredNotes) { note in
                    NavigationLink(value: note) {
                        noteCard(note: note)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        
                        Button(role: .destructive, action: {
                            modelContext.delete(note)
                        }, label: {
                            Label("Delete", systemImage: "trash.fill")
                        })
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                        Button(action: {
                            note.favorite.toggle()
                        }) {
                            Label("Toggle Bookmark", systemImage: "bookmark.fill")
                        }
                    }
                }
            }
            .navigationDestination(for: Note.self) {
                note in
                noteDetailView(note: note)
            }
            .overlay {
                if notes.isEmpty {
                    ContentUnavailableView {
                        Label("No Notes added", systemImage: "")
                    } description: {
                        Text("Press the plus to add a new note")
                    }
                }
            }
            .navigationTitle("Notes")
            .toolbar {
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showSheet = true
                    }, label: {
                        Image(systemName: "plus")
                    })
                    .sheet(isPresented: $showSheet) {
                        addNoteView()
                            .presentationDetents([.height(450)])
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
        .modelContainer(for: [Note.self], inMemory: true)
}
