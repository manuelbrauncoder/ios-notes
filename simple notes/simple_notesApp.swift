//
//  simple_notesApp.swift
//  simple notes
//
//  Created by Manuel Braun on 09.11.24.
//

import SwiftUI

@main
struct simple_notesApp: App {
    
    @AppStorage("selectedTheme") private var selectedTheme: Theme = .system

    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [Note.self])
                .preferredColorScheme(selectedTheme.colorScheme)
        }
    }
}
