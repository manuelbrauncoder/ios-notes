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
    
    
    var body: some View {
        
        TabView {
            
            Tab("Notes", systemImage: "note") {
                notesView()
            }
            .customizationID("1")
            .badge(notes.count)
            
            Tab(role: .search) {
                searchNotesView()
            }
            .customizationID("2")
            
            Tab("Trash", systemImage: "trash") {
                Text("Trash View coming soon")
            }
            .customizationID("3")
            
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
