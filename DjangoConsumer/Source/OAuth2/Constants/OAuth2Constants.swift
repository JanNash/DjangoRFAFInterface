//
//  OAuth2Constants.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 03.02.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD 3 Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation


// MARK: // Public
public struct OAuth2Constants {
    private init() {}
    
    public struct JSONKeys {
        private init() {}
        public static let accessToken: String   = "access_token"
        public static let refreshToken: String  = "refresh_token"
        public static let expiresIn: String     = "expires_in"
        public static let grantType: String     = "grant_type"
        public static let scope: String         = "scope"
        public static let username: String      = "username"
        public static let password: String      = "password"
        public static let token: String         = "token"
        public static let tokenType: String     = "token_type"
    }
    
    public struct GrantTypes {
        private init() {}
        public static let password: String      = "password"
        public static let refreshToken: String  = "refresh_token"
    }
    
    public struct Scopes {
        private init() {}
        public static let readWrite: String     = "read write"
    }
    
    public struct HeaderFields {
        private init() {}
        public static let authorization: String = "Authorization"
    }
    
    public struct HeaderValues {
        private init() {}
        public static func basic(_ appSecret: String) -> String    { return "Basic \(appSecret)" }
        public static func bearer(_ accessToken: String) -> String { return "Bearer \(accessToken)" }
    }
}
