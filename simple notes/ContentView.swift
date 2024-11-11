//
//  ContentView.swift
//  simple notes
//
//  Created by Manuel Braun on 09.11.24.
//

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
        }
        .tabViewStyle(.sidebarAdaptable)
        .tabViewCustomization($customization)
    }
}

#Preview {
    ContentView()
        
}
