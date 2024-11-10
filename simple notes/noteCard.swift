//
//  noteCard.swift
//  simple notes
//
//  Created by Manuel Braun on 10.11.24.
//

import Foundation
import SwiftUI

struct noteCard: View {
    
    @Bindable var note: Note
    
    var body: some View {
        
            VStack {
                HStack {
                    Text(note.title)
                        .font(.title)
                        .foregroundStyle(.black)
                    Spacer()
                    Image(systemName: note.favorite ? "bookmark.fill" : "bookmark")
                }
                
                Spacer().frame(height: 10)
                
                Text(truncatedText(note.note_text, limit: 20))
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(5)
            
        
    }
}


#Preview {
    @Previewable @State var note = Note(title: "note card", note_text: "Create a good looking note card", created_at: Date(), favorite: false)
    noteCard(note: note)
}
