//
//  notesList.swift
//  simple notes
//
//  Created by Manuel Braun on 13.11.24.
//

import Foundation
import SwiftUI
import SwiftData

struct notesList: View {
    
    @Query(filter: #Predicate<Note> { note in
        note.trashNote == false
    }) var notes: [Note]
    
    @Binding var showOnlyFavs: Bool
    @Binding var sortByTitle: Bool
    
    /// filter notes by title or show only favorite notes
    private var filteredNotes: [Note] {
        var result = notes
        if showOnlyFavs == true {
            result = result.filter { $0.favorite }
        }
        if sortByTitle == true {
            result = result.sorted { $0.title < $1.title }
        }
        return result
    }
    
    ///  set note.trashNote to true, remove reminder if available
    /// - Parameter note: the note for trash
    private func moveToTrash(note: Note) {
        if note.notificationID != nil {
            removeNotification(id: note.notificationID!)
        }
        note.trashNote = true
    }
    
    var body: some View {
        
        ForEach(filteredNotes) { note in
            NavigationLink(destination: noteDetailView(note: note)) {
                noteCard(note: note)
            }
            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                
                Button(role: .destructive, action: {
                    moveToTrash(note: note)
                }, label: {
                    Label("Delete", systemImage: "trash.fill")
                })
            }
            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                Button(action: {
                    note.favorite.toggle()
                }) {
                    Label("Favorite", systemImage: "bookmark.fill")
                }
            }
        }
    }
}


