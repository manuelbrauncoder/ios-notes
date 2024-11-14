//
//  noteCard.swift
//  simple notes
//
//  Created by Manuel Braun on 10.11.24.
//
// this is the single note in notesView

import Foundation
import SwiftUI

struct noteCard: View {
    
    @Bindable var note: Note
    
    var body: some View {
        
            VStack {
                HStack {
                    Image(systemName: "note")
                    Text(note.title)
                        .foregroundStyle(.primary)
                    Spacer()
                    Image(systemName: note.favorite ? "bookmark.fill" : "bookmark")
                }
            }
            .padding(5)
        }
    }


#Preview {
    @Previewable @State var note = Note(title: "note card", note_text: "Create a good looking note card", created_at: Date(), favorite: false)
    noteCard(note: note)
}
