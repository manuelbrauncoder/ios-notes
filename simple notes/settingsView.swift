//
//  settingsView.swift
//  simple notes
//
//  Created by Manuel Braun on 13.11.24.
//

import Foundation
import SwiftUI


struct settingsView: View {
    
    @AppStorage("selectedTheme") private var selectedTheme: Theme = .system
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Appearence")) {
                    Picker("Theme", selection: $selectedTheme) {
                        ForEach(Theme.allCases, id: \.self) { theme in
                            Text(theme.rawValue).tag(theme)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


#Preview {
    settingsView()
}
