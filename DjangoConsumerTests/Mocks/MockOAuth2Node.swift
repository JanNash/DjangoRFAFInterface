//
//  TestOAuth2Node.swift
//  DjangoRFAFInterfaceTests
//
//  Created by Jan Nash (privat) on 06.02.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation
import Alamofire
import DjangoConsumer


// MARK: // Internal
// MARK: Class Declaration
class MockOAuth2Node: DRFOAuth2Node {
    // Singleton
    static let main: MockOAuth2Node = MockOAuth2Node()
    
    // DRFNode Conformance
    // Basic Setup
    var baseURL: URL = URL(string: "")!
    
    // OAuth2Clients
    var oauth2Clients: [DRFOAuth2NodeAuthenticationClient] = []
    
    // OAuth2Handler
    lazy var oauth2Handler: DRFOAuth2Handler = {
        let baseURLWith: (String) -> URL = self.baseURL.appendingPathComponent
        
        let settings: DRFOAuth2Settings = DRFOAuth2Settings(
            appSecret: "",
            tokenRequestURL: baseURLWith(""),
            tokenRefreshURL: baseURLWith(""),
            tokenRevokeURL: baseURLWith("")
        )
        
        return DRFOAuth2Handler(
            settings: settings,
            credentialStore: TestOAuth2CredentialStore()
        )
    }()
    
    // Alamofire SessionManager
    // This is copied from the SessionManager implementation
    let sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        return SessionManager(configuration: configuration)
    }()
    
    // Pagination
    func defaultLimit<T>(for resourceType: T.Type) -> UInt where T : DRFListGettable {
        return 1000
    }
    
    // List GET endpoints
    func relativeListURL<T: DRFListGettable>(for resourceType: T.Type) -> URL {
        return self._relativeListURL(for: resourceType)
    }
}


// MARK: // Private
// MARK: DRFNode Implementations
private extension MockOAuth2Node {
    func _relativeListURL<T: DRFListGettable>(for resourceType: T.Type) -> URL {
        // ???: Didn't get a switch to work properly, what is the right syntax?
        if resourceType == MockListGettable.self {
            return URL(string: "listgettables/")!
        } else if resourceType == MockFilteredListGettable.self {
            return URL(string: "filteredlistgettables/")!
        }
        // FIXME: Throw a real Error here?
        fatalError("[MockOAuth2Node] No URL registered for '\(resourceType)'")
    }
}