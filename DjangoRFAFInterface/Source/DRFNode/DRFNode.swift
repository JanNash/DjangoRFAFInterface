//
//  DRFNode.swift
//  DjangoRFAFInterface
//
//  Created by Jan Nash (privat) on 18.01.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation


// MARK: // Public
// MARK: Protocol Declaration
public protocol DRFNode {
    var baseURL: URL { get }
    func listEndpoint<T: DRFListGettable>(for resourceType: T.Type) -> URL
    func parametersFrom(offset: UInt, limit: UInt) -> [String : Any]
}


// MARK: Default Implementations
public extension DRFNode {
    func parametersFrom(offset: UInt, limit: UInt) -> [String : Any] {
        return [
            DRFDefaultPagination.Keys.offset: offset,
            DRFDefaultPagination.Keys.limit: limit
        ]
    }
}
