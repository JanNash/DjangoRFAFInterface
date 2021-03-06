//
//  ResourceID.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 27.04.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Alamofire
import SwiftyJSON


// MARK: // Public
// MARK: Struct Declaration
public struct ResourceID<T: DetailResource> {
    public init?(_ string: String) {
        guard !string.isEmpty else { return nil }
        self.string = string
    }
    
    public private(set) var string: String
}


// MARK: Default Implementations
// MARK: where T: DetailGettableNoAuth
public extension ResourceID where T: DetailGettableNoAuth {
    func get(from node: NoAuthNode = T.defaultNoAuthNode) {
        DefaultImplementations.ResourceID.getResource(withID: self, from: node)
    }
}


// MARK: - DefaultImplementations.ResourceID
// MARK: where T: DetailGettable
public extension DefaultImplementations.ResourceID {
    static func getResource<T: DetailGettable>(withID resourceID: ResourceID<T>, from node: NoAuthNode) {
        self.getResource(withID: resourceID, from: node, via: node.sessionManagerNoAuth)
    }
    
    static func getResource<T: DetailGettable>(withID resourceID: ResourceID<T>, from node: Node, via sessionManager: SessionManagerType) {
        self._getResource(withID: resourceID, from: node, via: sessionManager)
    }
}


// MARK: // Private
// MARK: where T: DetailGettable
private extension DefaultImplementations.ResourceID {
    private static func _getResource<T: DetailGettable>(withID resourceID: ResourceID<T>, from node: Node, via sessionManager: SessionManagerType) {
        let url: URL = node.absoluteGETURL(for: resourceID)
        let method: ResourceHTTPMethod = .get
        let encoding: ParameterEncoding = URLEncoding.default
        
        func onSuccess(_ json: JSON) {
            let object: T = node.extractSingleObject(for: T.self, method: method, from: json)
            T.detailGettableClients.forEach({ $0.gotObject(object, for: resourceID, from: node)})
        }
        
        func onFailure(_ error: Error) {
            T.detailGettableClients.forEach({ $0.failedGettingObject(for: resourceID, from: node, with: error) })
        }
        
        sessionManager.fireRequest(
            with: .get(GETRequestConfiguration(url: url, encoding: encoding)),
            responseHandling: JSONResponseHandling(onSuccess: onSuccess, onFailure: onFailure)
        )
    }
}
