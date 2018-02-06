//
//  DRFNode.swift
//  DjangoConsumer
//
//  Created by Jan Nash (privat) on 18.01.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


// MARK: // Public
// MARK: Protocol Declaration
public protocol DRFNode {
    // Basic Setup
    var baseURL: URL { get }
    
    // Alamofire SessionManager
    // For now, it can not be safely assumed that external changes
    // made to this SessionManager instance will persist.
    // One example for this can be found in DRFOAuth2Node, where
    // the node accesses the sessionManager through a function
    // that sets its adapter and its retrier, so any previously
    // set adaptor retrier will be unset.
    var sessionManager: SessionManager { get }
    
    // Filtering
    func defaultFilters(for objectType: DRFFilteredListGettable.Type) -> [DRFFilterType]
    
    // Parameter Generation
    func parametersFrom(offset: UInt, limit: UInt, filters: [DRFFilterType]) -> Parameters
    func parametersFrom(offset: UInt, limit: UInt) -> Parameters
    func parametersFrom(filters: [DRFFilterType]) -> Parameters
    
    // List Request and Response Helpers
    func defaultLimit<T: DRFListGettable>(for resourceType: T.Type) -> UInt
    func paginationType<T: DRFListGettable>(for resourceType: T.Type) -> DRFPagination.Type
    func relativeListURL<T: DRFListGettable>(for resourceType: T.Type) -> URL
    func absoluteListURL<T: DRFListGettable>(for resourceType: T.Type) -> URL
    func extractListResponse<T: DRFListGettable>(for resourceType: T.Type, from json: JSON) -> (DRFPagination, [T])
}


// MARK: DRFDefaultListResponseKeys
public struct DRFDefaultListResponseKeys {
    public static let meta: String = "meta"
    public static let results: String = "results"
}


// MARK: Default Implementations
// MARK: Filtering
public extension DRFNode {
    func defaultFilters(for objectType: DRFFilteredListGettable.Type) -> [DRFFilterType] {
        return []
    }
}


// MARK: Parameter Generation
public extension DRFNode {
    func parametersFrom(offset: UInt, limit: UInt, filters: [DRFFilterType] = []) -> Parameters {
        return self._parametersFrom(offset: offset, limit: limit, filters: filters)
    }
    
    func parametersFrom(offset: UInt, limit: UInt) -> Parameters {
        return self._parametersFrom(offset: offset, limit: limit)
    }
    
    func parametersFrom(filters: [DRFFilterType]) -> Parameters {
        return filters.reduce(into: [:], { $0[$1.stringKey] = $1.value })
    }
}


// MARK: List Request and Response Helpers
public extension DRFNode {
    func paginationType<T>(for resourceType: T.Type) -> DRFPagination.Type where T : DRFListGettable {
        return DRFDefaultPagination.self
    }
    
    func absoluteListURL<T: DRFListGettable>(for resourceType: T.Type) -> URL {
        return self._absoluteListURL(for: resourceType)
    }
    
    func extractListResponse<T: DRFListGettable>(for resourceType: T.Type, from json: JSON) -> (DRFPagination, [T]) {
        return self._extractListResponse(for: resourceType, from: json)
    }
}


// MARK: // Private
// MARK: Parameter Generation Implementation
private extension DRFNode {
    func _parametersFrom(offset: UInt, limit: UInt, filters: [DRFFilterType] = []) -> Parameters {
        var parameters: Parameters = [:]
        let writeToParameters: (String, Any) -> Void = { parameters[$0] = $1 }
        self.parametersFrom(offset: offset, limit: limit).forEach(writeToParameters)
        self.parametersFrom(filters: filters).forEach(writeToParameters)
        return parameters
    }
    
    func _parametersFrom(offset: UInt, limit: UInt) -> Parameters {
        return [
            DRFDefaultPagination.Keys.offset: offset,
            DRFDefaultPagination.Keys.limit: limit
        ]
    }
}


// MARK: List Request and Response Helper Implementations
private extension DRFNode {
    func _absoluteListURL<T: DRFListGettable>(for resourceType: T.Type) -> URL {
        let relativeURL: URL = self.relativeListURL(for: resourceType)
        return self.baseURL.appendingPathComponent(relativeURL.absoluteString)
    }
    
    func _extractListResponse<T: DRFListGettable>(for resourceType: T.Type, from json: JSON) -> (DRFPagination, [T]) {
        let paginationType: DRFPagination.Type = self.paginationType(for: resourceType)
        let pagination: DRFPagination = paginationType.init(json: json[DRFDefaultListResponseKeys.meta])
        let objects: [T] = json[DRFDefaultListResponseKeys.results].array!.map(T.init)
        return (pagination, objects)
    }
}
