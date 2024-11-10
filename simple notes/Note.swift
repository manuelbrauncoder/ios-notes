//
//  Note.swift
//  simple notes
//
//  Created by Manuel Braun on 09.11.24.
//

import Foundation
import SwiftData

@Model
class Note {
    var title: String
    var note_text: String
    var created_at: Date
    var favorite: Bool
    
    init(title: String, note_text: String, created_at: Date, favorite: Bool) {
        self.title = title
        self.note_text = note_text
        self.created_at = created_at
        self.favorite = favorite
    }
}
