//
//  Note.swift
//  simple notes
//
//  Created by Manuel Braun on 09.11.24.
//
// The model for the Note
// stored in swift data

import Foundation
import SwiftData

@Model
class Note {
    var title: String
    var note_text: String
    var created_at: Date
    var favorite: Bool
    var notificationID: String?
    var reminder: Date?
    var trashNote: Bool
    
    @Attribute(.externalStorage)
    var imgData: Data?
    
    init(title: String, note_text: String, created_at: Date, favorite: Bool, notificationID: String? = nil, reminder: Date? = nil, imgData: Data? = nil, trashNote: Bool = false) {
        self.title = title
        self.note_text = note_text
        self.created_at = created_at
        self.favorite = favorite
        self.notificationID = notificationID
        self.reminder = reminder
        self.imgData = imgData
        self.trashNote = trashNote
    }
}
