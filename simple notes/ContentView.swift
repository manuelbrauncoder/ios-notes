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
    
    @Query var notes: [Note]
    @Query var folders: [Folder]
    
    @State private var searchTerm = ""
    
    @AppStorage("biometricLogin") private var biometricLogin = false
    
    @State private var biometricAuthentication = BiometricAuthentication()
    
    
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
        
        if !biometricLogin || biometricAuthentication.isAuthorized {
            
            NavigationStack {
                List {
                    if !searchTerm.isEmpty {
                        ForEach(filteredNotes) { note in
                            NavigationLink(destination: NoteDetailView(note: note)) {
                                NoteCard(note: note)
                            }
                        }
                    } else {
                        if !folders.isEmpty {
                            Section("Folders") {
                                ForEach(folders) { folder in
                                    NavigationLink(destination: FolderDetailView(folder: folder)) {
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
                        BottomToolBarButtons()
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu(content: {
                            NavigationLink {
                                SettingsView()
                            } label: {
                                Image(systemName: "gearshape.fill")
                                Text("Settings")
                            }
                            NavigationLink {
                                TrashView()
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
            .tint(.yellow)
        } else {
            VStack {
                if let biometricType = biometricAuthentication.getBiometricType() {
                    Image(systemName: biometricType.getIconName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                    Text("Unlock with \(biometricType.getText)")
                        .font(.title)
                }
            }
            .onAppear {
                biometricAuthentication.biometricLogin()
            }
        }
        
    }
}

#Preview {
    ContentView()
    
}
