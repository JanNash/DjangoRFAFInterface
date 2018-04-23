//
//  RequestConfiguration.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 08.04.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation
import Alamofire


// MARK: // Public
// MARK: - RequestConfiguration
public struct RequestConfiguration {
    public init(url: URL, method: ResourceHTTPMethod, parameters: Parameters = [:], encoding: ParameterEncoding, headers: HTTPHeaders = [:], acceptableStatusCodes: [Int] = Array(200..<300), acceptableContentTypes: [String] = ["*/*"]) {
        self.url = url
        self.method = method
        self.parameters = parameters
        self.encoding = encoding
        self.headers = headers
        self.acceptableStatusCodes = acceptableStatusCodes
        self.acceptableContentTypes = acceptableContentTypes
    }
    
    public var url: URL
    public var method: ResourceHTTPMethod
    public var parameters: Parameters
    public var encoding: ParameterEncoding
    public var headers: HTTPHeaders
    public var acceptableStatusCodes: [Int]
    public var acceptableContentTypes: [String]
}