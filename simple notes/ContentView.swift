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
    @Query var folders: [Folder]
    @State private var searchTerm = ""
    @State private var showAddNoteSheet = false
    @State private var showAddFolderSheet = false
    
    
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
                if !searchTerm.isEmpty {
                    ForEach(filteredNotes) { note in
                        NavigationLink(destination: noteDetailView(note: note)) {
                            noteCard(note: note)
                        }
                    }
                } else {
                    if !folders.isEmpty {
                        Section("Folders") {
                            ForEach(folders) { folder in
                                NavigationLink(destination: folderDetailView(folder: folder)) {
                                    HStack {
                                        Image(systemName: "folder")
                                            .foregroundStyle(.yellow)
                                        Text(folder.name)
                                    }
                                    .padding(5)
                                    .badge(folder.notes?.count ?? 0)
                                }
                            }
                        }
                        Section("All") {
                            NavigationLink(destination: AllNotesView()) {
                                HStack {
                                    Image(systemName: "folder")
                                        .foregroundStyle(.yellow)
                                    Text("All Notes")
                                }
                                .padding(5)
                                .badge(notes.count)
                            }
                            
                        }
                    }
                }
                
            }
            .navigationTitle("Folders")
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    BottomToolBar()
                }
               
                ToolbarItem(placement: .topBarTrailing) {
                    Menu(content: {
                        NavigationLink {
                            settingsView()
                        } label: {
                            Image(systemName: "gearshape.fill")
                            Text("Settings")
                        }
                        NavigationLink {
                            trashView()
                        } label: {
                            Image(systemName: "trash")
                            Text("Trash")
                        }
                        
                    }, label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundStyle(.yellow)
                    })
                    
                }
                
            }
        }
        .searchable(text: $searchTerm)
        
        
    }
}

#Preview {
    ContentView()
    
}
