//
//  ContentView.swift
//  simple notes
//
//  Created by Manuel Braun on 09.11.24.
//
// The root view of the App

import SwiftUI
import SwiftData
import UserNotifications

struct ContentView: View {
    
    @AppStorage("MyTabViewCustomization")
    private var customization: TabViewCustomization
    
    @Query var notes: [Note]
    
    
    /// Count the notes
    /// - Parameter countTrash: true for trash, false for normal note
    /// - Returns: the number of notes
    private func countNotes(countTrash: Bool) -> Int {
        var counter = 0
        notes.forEach { note in
            if note.trashNote == countTrash {
                counter += 1
            }
        }
        return counter
    }
    
    var body: some View {
        
        TabView {
            
            Tab("Notes", systemImage: "note") {
                notesView()
            }
            .customizationID("1")
            .badge(countNotes(countTrash: false))
            
            Tab(role: .search) {
                searchNotesView()
            }
            .customizationID("2")
            
            Tab("Trash", systemImage: "trash") {
                trashView()
            }
            .customizationID("3")
            .badge(countNotes(countTrash: true))
            
            Tab("More", systemImage: "ellipsis") {
                moreView()
            }
            .customizationID("4")
            
           
            
        }
        .tabViewStyle(.sidebarAdaptable)
        .tabViewCustomization($customization)
    }
}

#Preview {
    ContentView()
    
}
