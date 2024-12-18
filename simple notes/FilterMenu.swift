//
//  filterMenu.swift
//  simple notes
//
//  Created by Manuel Braun on 10.11.24.
//
// This file handles the filter menu
// currently ists calles in notesView

import Foundation
import SwiftUI


struct FilterMenu: View {
    
    @Binding var showOnlyFavs: Bool
    @Binding var sortByTitle: Bool
    
    var body: some View {
        Menu {
            Button(action: {
                showOnlyFavs.toggle()
            }) {
                if showOnlyFavs {
                    Label("All", systemImage: "bookmark")
                    
                } else {
                    Label("Favorites", systemImage: "bookmark.fill")
                }
            }
            Button(action: {
                sortByTitle.toggle()
            }) {
                Label("Sort by Title", systemImage: "arrow.up.arrow.down")
            }
        } label: {
            Label("Options", systemImage: "line.3.horizontal.decrease")
                .tint(.yellow)
        }
    }
}


#Preview {
    @Previewable @State var showOnlyFavs = false
    @Previewable @State var sortByTitle = false
    FilterMenu(showOnlyFavs: $showOnlyFavs, sortByTitle: $sortByTitle)
}

