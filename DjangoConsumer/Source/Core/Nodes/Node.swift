//
//  Node.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 18.01.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD 3 Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Alamofire
import SwiftyJSON


// MARK: // Public
public protocol Node {
    // Basic Setup
    var baseURL: URL { get }
    
    // Routes
    var routes: [Route] { get }
    
    // List GET Request Helpers
    func defaultLimit<T: ListGettable>(for resourceType: T.Type) -> UInt
    func defaultFilters(for resourceType: FilteredListGettable.Type) -> [FilterType]
    func paginationType<T: ListGettable>(for resourceType: T.Type) -> Pagination.Type
    
    // URL Parameter Generation
    func parametersFrom(filters: [FilterType]) -> Payload.JSON.Dict
    func parametersFrom(offset: UInt, limit: UInt) -> Payload.JSON.Dict
    func parametersFrom(offset: UInt, limit: UInt, filters: [FilterType]) -> Payload.JSON.Dict
    
    // Request Payload Generation
    func payloadFrom(object: PayloadConvertible, method: ResourceHTTPMethod, conversion: PayloadConversion) -> Payload
    func payloadFrom<C: Collection, T: ListPostable>(listPostables: C, conversion: PayloadConversion) -> Payload where C.Element == T
    
    // URLs
    // MetaResource.Type URLs
    func relativeURL(for resourceType: MetaResource.Type, routeType: RouteType) -> URL
    func absoluteURL(for resourceType: MetaResource.Type, routeType: RouteType) -> URL
    
    // IdentifiableResource URLs
    func relativeURL<T: IdentifiableResource>(for resource: T, routeType: RouteType.Detail) throws -> URL
    func absoluteURL<T: IdentifiableResource>(for resource: T, routeType: RouteType.Detail) throws -> URL
    
    // ResourceID URLs
    func relativeGETURL<T: DetailGettable>(for resourceID: ResourceID<T>) -> URL
    func absoluteGETURL<T: DetailGettable>(for resourceID: ResourceID<T>) -> URL
    
    // Response Extraction
    // Detail Response Extraction Helpers
    func extractSingleObject<T: JSONInitializable>(for resourceType: T.Type, method: ResourceHTTPMethod, from json: JSON) -> T
    
    // List Response Extraction Helpers
    func extractGETListResponsePagination(with paginationType: Pagination.Type, from json: JSON) -> Pagination
    func extractGETListResponseObjects<T: ListGettable>(for resourceType: T.Type, from json: JSON) -> [T]
    func extractGETListResponse<T: ListGettable>(for resourceType: T.Type, from json: JSON) -> (Pagination, [T])
    func extractPOSTListResponse<T: ListPostable>(for resourceType: T.Type, from json: JSON) -> [T]
}


// MARK: Default Implementations
// MARK: List GET Request Helpers
public extension Node {
    func defaultFilters(for resourceType: FilteredListGettable.Type) -> [FilterType] {
        return DefaultImplementations.Node.defaultFilters(node: self, for: resourceType)
    }
    
    func paginationType<T: ListGettable>(for resourceType: T.Type) -> Pagination.Type {
        return DefaultImplementations.Node.paginationType(node: self, for: resourceType)
    }
}


// MARK: URL Parameter Generation
public extension Node {
    func parametersFrom(filters: [FilterType]) -> Payload.JSON.Dict {
        return DefaultImplementations.Node.parametersFrom(node: self, filters: filters)
    }
    
    func parametersFrom(offset: UInt, limit: UInt) -> Payload.JSON.Dict {
        return DefaultImplementations.Node.parametersFrom(node: self, offset: offset, limit: limit)
    }
    
    func parametersFrom(offset: UInt, limit: UInt, filters: [FilterType] = []) -> Payload.JSON.Dict {
        return DefaultImplementations.Node.parametersFrom(node: self, offset: offset, limit: limit, filters: filters)
    }
}


// MARK: Request Payload Generation
public extension Node {
    func payloadFrom(object: PayloadConvertible, method: ResourceHTTPMethod, conversion: PayloadConversion) -> Payload {
        return DefaultImplementations.Node.payloadFrom(node: self, object: object, method: method, conversion: conversion)
    }
    
    func payloadFrom<C: Collection, T: ListPostable>(listPostables: C, conversion: PayloadConversion) -> Payload where C.Element == T {
        return DefaultImplementations.Node.payloadFrom(node: self, listPostables: listPostables, conversion: conversion)
    }
}


// MARK: Request URL Helpers
public extension Node {
    // MetaResource.Type URLs
    func relativeURL(for resourceType: MetaResource.Type, routeType: RouteType) -> URL {
        return DefaultImplementations.Node.relativeURL(node: self, for: resourceType, routeType: routeType)
    }
    
    func absoluteURL(for resourceType: MetaResource.Type, routeType: RouteType) -> URL {
        return DefaultImplementations.Node.absoluteURL(node: self, for: resourceType, routeType: routeType)
    }
    
    // IdentifiableResource URLs
    func relativeURL<T: IdentifiableResource>(for resource: T, routeType: RouteType.Detail) throws -> URL {
        return try DefaultImplementations.Node.relativeURL(node: self, for: resource, routeType: routeType)
    }
    
    func absoluteURL<T: IdentifiableResource>(for resource: T, routeType: RouteType.Detail) throws -> URL {
        return try DefaultImplementations.Node.absoluteURL(node: self, for: resource, routeType: routeType)
    }
    
    // ResourceID URLs
    func relativeGETURL<T: DetailGettable>(for resourceID: ResourceID<T>) -> URL {
        return DefaultImplementations.Node.relativeGETURL(node: self, for: resourceID)
    }
    
    func absoluteGETURL<T: DetailGettable>(for resourceID: ResourceID<T>) -> URL {
        return DefaultImplementations.Node.absoluteGETURL(node: self, for: resourceID)
    }
}


// MARK: Detail Response Extraction Helpers
public extension Node {
    func extractSingleObject<T: JSONInitializable>(for resourceType: T.Type, method: ResourceHTTPMethod, from json: JSON) -> T {
        return DefaultImplementations.Node.extractSingleObject(node: self, for: resourceType, method: method, from: json)
    }
}


// MARK: List Response Extraction Helpers
public extension Node {
    func extractGETListResponsePagination(with paginationType: Pagination.Type, from json: JSON) -> Pagination {
        return DefaultImplementations.Node.extractGETListResponsePagination(node: self, with: paginationType, from: json)
    }
    
    func extractGETListResponseObjects<T: ListGettable>(for resourceType: T.Type, from json: JSON) -> [T] {
        return DefaultImplementations.Node.extractGETListResponseObjects(node: self, for: T.self, from: json)
    }
    
    func extractGETListResponse<T: ListGettable>(for resourceType: T.Type, from json: JSON) -> (Pagination, [T]) {
        return DefaultImplementations.Node.extractGETListResponse(node: self, for: resourceType, from: json)
    }
    
    func extractPOSTListResponse<T: ListPostable>(for resourceType: T.Type, from json: JSON) -> [T] {
        return DefaultImplementations.Node.extractPOSTListResponse(node: self, for: resourceType, from: json)
    }
}


// MARK: - DefaultImplementations.Node
// MARK: Request/Response Keys
public extension DefaultImplementations.Node {
    enum ListRequestKeys {
        public static let objects: String = "objects"
    }
    
    enum ListResponseKeys {
        public static let meta: String = "meta"
        public static let results: String = "results"
    }
}


// MARK: List GET Request Helpers
public extension DefaultImplementations.Node {
    static func defaultFilters(node: Node, for resourceType: FilteredListGettable.Type) -> [FilterType] {
        return []
    }
    
    static func paginationType<T: ListGettable>(node: Node, for resourceType: T.Type) -> Pagination.Type {
        return DefaultPagination.self
    }
}


// MARK: URL Parameter Generation
public extension DefaultImplementations.Node {
    static func parametersFrom(node: Node, filters: [FilterType]) -> Payload.JSON.Dict {
        return Payload.JSON.Dict(filters.mapToDict({ ($0.stringKey, $0.value) }, strategy: .overwriteOldValue))
    }
    
    static func parametersFrom(node: Node, offset: UInt, limit: UInt) -> Payload.JSON.Dict {
        return self._parametersFrom(node: node, offset: offset, limit: limit)
    }
    
    static func parametersFrom(node: Node, offset: UInt, limit: UInt, filters: [FilterType] = []) -> Payload.JSON.Dict {
        return self._parametersFrom(node: node, offset: offset, limit: limit, filters: filters)
    }
}


// MARK: Request Payload Generation
public extension DefaultImplementations.Node {
    static func payloadFrom(node: Node, object: PayloadConvertible, method: ResourceHTTPMethod, conversion: PayloadConversion) -> Payload {
        return object.toPayload(conversion: conversion, method: method)
    }
    
    static func payloadFrom<C: Collection, T: ListPostable>(node: Node, listPostables: C, conversion: PayloadConversion) -> Payload where C.Element == T {
        return Payload.Dict([ListRequestKeys.objects: listPostables.map({ $0.payloadDict(rootObject: $0, method: .post) })]).toPayload(conversion: conversion, rootObject: nil, method: .post)
    }
}


// MARK: Request URL Helpers
public extension DefaultImplementations.Node {
    // MetaResource.Type URLs
    static func relativeURL(node: Node, for resourceType: MetaResource.Type, routeType: RouteType) -> URL {
        return self._relativeURL(node: node, for: resourceType, routeType: routeType)
    }
    
    static func absoluteURL(node: Node, for resourceType: MetaResource.Type, routeType: RouteType) -> URL {
        return node.baseURL + node.relativeURL(for: resourceType, routeType: routeType)
    }
    
    // IdentifiableResource URLs
    static func relativeURL<T: IdentifiableResource>(node: Node, for resource: T, routeType: RouteType.Detail) throws -> URL {
        guard let resourceID: ResourceID<T> = resource.id else { throw IdentifiableResourceError.hasNoID }
        return node.relativeURL(for: T.self, routeType: routeType) + resourceID
    }
    
    static func absoluteURL<T: IdentifiableResource>(node: Node, for resource: T, routeType: RouteType.Detail) throws -> URL {
        return try node.baseURL + node.relativeURL(for: resource, routeType: routeType)
    }
    
    // ResourceID URLs
    static func relativeGETURL<T: DetailGettable>(node: Node, for resourceID: ResourceID<T>) -> URL {
        return node.relativeURL(for: T.self, routeType: .detailGET) + resourceID
    }
    
    static func absoluteGETURL<T: DetailGettable>(node: Node, for resourceID: ResourceID<T>) -> URL {
        return node.baseURL + node.relativeGETURL(for: resourceID)
    }
}


// MARK: Detail Response Extraction Helpers
public extension DefaultImplementations.Node {
    static func extractSingleObject<T: JSONInitializable>(node: Node, for resourceType: T.Type, method: ResourceHTTPMethod, from json: JSON) -> T {
        return T(json: json)
    }
}


// MARK: List Response Extraction Helpers
public extension DefaultImplementations.Node {
    static func extractGETListResponsePagination(node: Node, with paginationType: Pagination.Type, from json: JSON) -> Pagination {
        return paginationType.init(json: json[ListResponseKeys.meta])
    }
    
    static func extractGETListResponseObjects<T: ListGettable>(node: Node, for resourceType: T.Type, from json: JSON) -> [T] {
        return json[ListResponseKeys.results].array!.map(T.init)
    }
    
    static func extractGETListResponse<T: ListGettable>(node: Node, for resourceType: T.Type, from json: JSON) -> (Pagination, [T]) {
        return self._extractGETListResponse(node: node, for: resourceType, from: json)
    }
        
    static func extractPOSTListResponse<T: ListPostable>(node: Node, for resourceType: T.Type, from json: JSON) -> [T] {
        return json[ListResponseKeys.results].array!.map(T.init)
    }
}


// MARK: // Private
// MARK: URL Parameter Generation Implementations
private extension DefaultImplementations.Node {
    private static func _parametersFrom(node: Node, offset: UInt, limit: UInt, filters: [FilterType] = []) -> Payload.JSON.Dict {
        var parameters: Payload.JSON.Dict = [:]
        let writeToParameters: (String, JSONValueConvertible) -> Void = { parameters[$0] = $1 }
        node.parametersFrom(offset: offset, limit: limit).forEach(writeToParameters)
        node.parametersFrom(filters: filters).forEach(writeToParameters)
        return parameters
    }
    
    private static func _parametersFrom(node: Node, offset: UInt, limit: UInt) -> Payload.JSON.Dict {
        return [
            DefaultPagination.Keys.offset: offset,
            DefaultPagination.Keys.limit: limit
        ]
    }
}


// MARK: Request URL Helper Implementations
private extension DefaultImplementations.Node {
    private static func _relativeURL(node: Node, for resourceType: MetaResource.Type, routeType: RouteType) -> URL {
        let availableRoutes: [Route] = node.routes.filter(Route.matches(resourceType, routeType))
        
        guard availableRoutes.count > 0 else {
            fatalError(
                "[DjangoConsumer.Node] No Route registered in '\(node)' for type " +
                "'\(resourceType)', routeType '\(routeType)'"
            )
        }
        
        guard availableRoutes.count == 1 else {
            fatalError(
                "[DjangoConsumer.Node] Multiple Routes registered in '\(node)' for type " +
                "'\(resourceType)', routeType '\(routeType)'"
            )
        }
        
        return availableRoutes[0].relativeURL
    }
}


// MARK: List Response Extraction Helper Implementations
private extension DefaultImplementations.Node {
    private static func _extractGETListResponse<T: ListGettable>(node: Node, for resourceType: T.Type, from json: JSON) -> (Pagination, [T]) {
        let paginationType: Pagination.Type = node.paginationType(for: resourceType)
        let pagination: Pagination = node.extractGETListResponsePagination(with: paginationType, from: json)
        let objects: [T] = node.extractGETListResponseObjects(for: T.self, from: json)
        return (pagination, objects)
    }
}
