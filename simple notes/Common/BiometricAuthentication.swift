//
//  BiometricAuthentication.swift
//  simple notes
//
//  Created by Manuel Braun on 17.11.24.
//

import Foundation
import LocalAuthentication

enum BiometricType {
    case touch
    case face
    case optic
    
    var getText: String {
        switch self {
        case .touch:
            "Touch ID"
        case .face:
            "Face ID"
        case .optic:
            "Optic ID"
        }
    }
    
    var getIconName: String {
        switch self {
        case .touch:
            "touchid"
        case .face:
            "faceid"
        case .optic:
            "opticid"
        }
    }
}

@Observable
class BiometricAuthentication {
    
    var isAuthorized = false
    var failed = false
    
    private let authenticationContext = LAContext()
    
    func biometricLogin() {
        guard let biometricType = getBiometricType() else {
            failed = true
            return
        }
        let reason = "\(biometricType.getText) Authentication"
        authenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { isAuthorized, error in
            self.isAuthorized = isAuthorized
            self.failed = error != nil
        }
    }
    
    func getBiometricType() -> BiometricType? {
        guard canEvaluatePolicy() else { return nil }
        
        switch authenticationContext.biometryType {
        case .faceID:
            return .face
        case .touchID:
            return .touch
        case .opticID:
            return .optic
        default: return nil
        }
    }
    
    private func canEvaluatePolicy() -> Bool {
        var error: NSError?
        let canEvaluate = authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        if let error = error { print(error) }
        return canEvaluate
    }
    
}
