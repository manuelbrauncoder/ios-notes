//
//  bottomToolbar.swift
//  simple notes
//
//  Created by Manuel Braun on 17.11.24.
//

import Foundation
import SwiftUI


struct BottomToolBar: View {
    
    @State private var showAddFolderSheet = false
    @State private var showAddNoteSheet = false
    
    var body: some View {
        
            Button(action: {
                showAddFolderSheet = true
            }, label: {
                Image(systemName: "folder.badge.plus")
                    .foregroundStyle(.yellow)
            })
            .sheet(isPresented: $showAddFolderSheet) {
                addFolderView()
            }
            
            Button(action: {
                showAddNoteSheet = true
            }, label: {
                Image(systemName: "square.and.pencil")
                    .foregroundStyle(.yellow)
            })
            .sheet(isPresented: $showAddNoteSheet) {
                addNoteView()
            }
        }
    }



#Preview {
    BottomToolBar()
}
