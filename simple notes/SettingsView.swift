//
//  settingsView.swift
//  simple notes
//
//  Created by Manuel Braun on 13.11.24.
//

import Foundation
import SwiftUI


struct SettingsView: View {
    
    @AppStorage("selectedTheme") private var selectedTheme: Theme = .system
    @AppStorage("biometricLogin") private var biometricLogin = false
    
    @State private var biometricAuthentication = BiometricAuthentication()
    
    
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
                
                if let biometricTpe = biometricAuthentication.getBiometricType() {
                    Section("Authentication") {
                        Toggle("Use \(biometricTpe.getText)", isOn: $biometricLogin)
                            .onChange(of: biometricLogin) {
                                biometricAuthentication.biometricLogin()
                            }
                    }
                }
         //       Section("Face ID") {
         //
         //           Toggle("Use Face ID?", isOn: $biometricLogin)
         //               .onChange(of: biometricLogin) {
         //
         //               }
         //
         //           if biometricAuthentication.isAuthorized {
         //               Text("Test")
         //           } else {
         //               if let biometricType = biometricAuthentication.getBiometricType() {
         //                   VStack {
         //                       Text(biometricType.getText)
         //                       Button(action: {
         //                           biometricAuthentication.biometricLogin()
         //                       }, label: {
         //                           Image(systemName: biometricType.getIconName)
         //                       })
         //                       if biometricAuthentication.failed {
         //                           Text("Error")
         //                       }
         //                   }
         //               } else {
         //                   Text("Biometric Login not available")
         //               }
         //           }
         //       }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


#Preview {
    SettingsView()
}
