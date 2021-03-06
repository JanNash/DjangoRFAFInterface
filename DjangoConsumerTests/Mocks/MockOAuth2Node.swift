//
//  TestOAuth2Node.swift
//  DjangoRFAFInterfaceTests
//
//  Created by Jan Nash on 06.02.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD 3 Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation
import Alamofire
import DjangoConsumer


// MARK: // Internal
// MARK: OAuth2Node Convenience Extension
extension OAuth2Node {
    var testDelegate: TestSessionDelegate? {
        return (self.sessionManagerOAuth2 as? TestSessionManager)?.testDelegate
    }
}


// MARK: Class Declaration
class MockOAuth2Node: OAuth2Node {
    // Singleton
    static let main: MockOAuth2Node = MockOAuth2Node()
    
    // Node Conformance
    // SessionManager
    let sessionManagerOAuth2: SessionManagerType = TestSessionManager()
    
    // Base URL
    var baseURL: URL = URL(string: "http://localhost:8080")!
    
    // Routes
    var routes: [Route] = []
    
    // Pagination
    func defaultLimit<T: ListGettable>(for resourceType: T.Type) -> UInt {
        return 1000
    }
    
    // OAuth2Node Conformance
    // OAuth2Clients
    var oauth2Clients: [OAuth2NodeAuthenticationClient] = []
    
    // OAuth2Handler
    lazy var oauth2Handler: OAuth2Handler = {
        let baseURLWith: (String) -> URL = self.baseURL.appendingPathComponent
        
        let settings: OAuth2Settings = OAuth2Settings(
            appSecret: "",
            tokenRequestURL: baseURLWith(""),
            tokenRefreshURL: baseURLWith(""),
            tokenRevokeURL: baseURLWith("")
        )
        
        return OAuth2Handler(
            settings: settings,
            credentialStore: TestOAuth2CredentialStore()
        )
    }()
}
