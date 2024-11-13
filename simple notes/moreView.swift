//
//  moreView.swift
//  simple notes
//
//  Created by Manuel Braun on 13.11.24.
//

import Foundation
import SwiftUI

struct moreView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                    settingsView()
                } label: {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
            }
            .navigationTitle("More")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


#Preview {
    moreView()
}
