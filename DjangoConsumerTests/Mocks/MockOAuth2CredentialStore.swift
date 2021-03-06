//
//  TestOAuth2CredentialStore.swift
//  DjangoRFAFInterfaceTests
//
//  Created by Jan Nash on 06.02.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD 3 Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation
import DjangoConsumer


// MARK: // Internal
struct TestOAuth2CredentialStore: OAuth2CredentialStore {
    // Variables
    var accessToken: String?
    var refreshToken: String?
    var expiryDate: Date?
    var tokenType: String?
    var scope: String?
    
    // Functions
    mutating func updateWith(accessToken: String, refreshToken: String, expiryDate: Date, tokenType: String, scope: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expiryDate = expiryDate
        self.tokenType = tokenType
        self.scope = scope
    }
    
    mutating func clear() {
        self.accessToken = nil
        self.refreshToken = nil
        self.expiryDate = nil
        self.tokenType = nil
        self.scope = nil
    }
}
