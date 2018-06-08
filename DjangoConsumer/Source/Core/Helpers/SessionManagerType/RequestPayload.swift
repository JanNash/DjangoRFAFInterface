//
//  RequestPayload.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 30.05.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation
import Alamofire


// MARK: // Public
// MARK: -
public typealias MultipartDict = [String: (Data, MimeType)]


// MARK: -
public enum UnwrappedRequestPayload {
    case parameters(Parameters)
    case multipart(MultipartDict)
}


// MARK: -
extension RequestPayload {
    public typealias UnwrappingStrategy = (RequestPayload)
    
    func unwrap() -> UnwrappedRequestPayload {
        return self._unwrap()
    }
}


// MARK: -
public indirect enum RequestPayload: Equatable {
    case json(JSONDict)
    case multipart([FormData])
    case nested(String, [RequestPayload])
}


// MARK: - Array where Element == (String, RequestPayload)
extension Array where Element == (String, RequestPayload) {
    public static func == (_ lhs: [Element], _ rhs: [Element]) -> Bool {
        return self._equals(lhs, rhs)
    }
}


// MARK: -
extension FormData {
    public func unwrap() -> [String: Data] {
        return self._unwrap()
    }
}


// MARK: -
//extension Collection where Element == FormData {
//    public func unwrap() -> [String: Data] {
//        return self.map({ $0.unwrap() })
//    }
//}


// MARK: -
public enum FormData: Equatable {
    case json(JSONDict)
    case image(key: String, image: UIImage, mimeType: MimeType.Image)
    case nested([(String, RequestPayload)])
    
    public static func == (lhs: FormData, rhs: FormData) -> Bool {
        return self._equals(lhs, rhs)
    }
}


// MARK: -
public enum MimeType: String {
    case applicationJSON = "application/json"
    case imageJPEG = "image/jpeg"
    case imagePNG = "image/png"
    
    public enum Application: Equatable {
        case json
    }
    
    public enum Image: Equatable {
        case jpeg(compressionQuality: CGFloat)
        case png
    }
}


// MARK: // Private
private let jsonNullData: (Data, MimeType) = ("null".data(using: .utf8)!, .applicationJSON)

private func += <K, V>(_ lhs: inout Dictionary<K, V>, _ rhs: Dictionary<K, V>) {
    return lhs.merge(rhs, uniquingKeysWith: { _, r in r })
}

// MARK: -
private extension RequestPayload {
    func _encodeIndexedKey(key: String, index: Int) -> String {
        return key + "[\(index)]"
    }
    
    func _encodeNestedKeys(outerKey: String?, innerKey: String) -> String {
        guard let outerKey: String = outerKey else { return innerKey }
        return outerKey + "." + innerKey
    }
    
    func _encodeImage(_ image: UIImage, mimeType: MimeType.Image) -> (Data, MimeType) {
        switch mimeType {
        case .jpeg(let compressionQuality):
            return (UIImageJPEGRepresentation(image, compressionQuality)!, .imageJPEG)
        case .png:
            return (UIImagePNGRepresentation(image)!, .imagePNG)
        }
    }
    
    func _mergeJSONValue(_ value: JSONValue, toMultipart multipart: inout MultipartDict, prefixKey: String) {
        switch value.typedValue {
        case .dict(let dict):
            if let dict: JSONDict = dict {
                multipart += self._multipartDict(from: dict, prefixKey: prefixKey)
            } else {
                multipart[prefixKey] = jsonNullData
            }
        case .array(let array):
            if let array: [JSONValue] = array {
                multipart += self._multipartDict(from: array, prefixKey: prefixKey)
            } else {
                multipart[prefixKey] = jsonNullData
            }
        default:
            multipart[prefixKey] = (value.toData(), .applicationJSON)
        }
    }
    
    func _multipartDict(from jsonDict: JSONDict, prefixKey: String?) -> MultipartDict {
        var result: MultipartDict = [:]
        
        jsonDict.dict.forEach({ key, value in
            let innerPrefixKey: String = self._encodeNestedKeys(outerKey: prefixKey, innerKey: key)
            self._mergeJSONValue(value, toMultipart: &result, prefixKey: innerPrefixKey)
        })
        
        return result
    }
    
    func _multipartDict(from jsonArray: [JSONValue], prefixKey: String) -> MultipartDict {
        var result: MultipartDict = [:]
        
        jsonArray.enumerated().forEach({
            let innerPrefixKey: String = self._encodeIndexedKey(key: prefixKey, index: $0.offset)
            self._mergeJSONValue($0.element, toMultipart: &result, prefixKey: innerPrefixKey)
        })
        
        return result
    }
    
    func _mergeJSONDict(_ jsonDict: JSONDict, prefixKey: String?, toParameters parameters: inout Parameters, toMultipart multipart: inout MultipartDict) {
        let unwrappedJSONDict: Parameters = jsonDict.unwrap()
        if let key: String = prefixKey {
            parameters[key] = unwrappedJSONDict
        } else {
            parameters += unwrappedJSONDict
        }
        
        multipart += self._multipartDict(from: jsonDict, prefixKey: prefixKey)
    }
    
    func _mergeFormData(_ formData: FormData, prefixKey: String?, toParameters parameters: inout Parameters, toMultipart multipart: inout MultipartDict) {
        switch formData {
        case .json(let jsonDict):
            self._mergeJSONDict(jsonDict, prefixKey: prefixKey, toParameters: &parameters, toMultipart: &multipart)
        case .image(let key, let image, let mimeType):
            let innerPrefixKey: String = self._encodeNestedKeys(outerKey: prefixKey, innerKey: key)
            multipart[innerPrefixKey] = self._encodeImage(image, mimeType: mimeType)
        case .nested(let keyedPayloadArray):
            keyedPayloadArray.forEach({
                let innerPrefixKey: String = self._encodeNestedKeys(outerKey: prefixKey, innerKey: $0.0)
                self._mergeRequestPayload($0.1, prefixKey: innerPrefixKey, toParameters: &parameters, toMultipart: &multipart)
            })
        }
    }
    
    func _mergeRequestPayload(_ requestPayload: RequestPayload, prefixKey: String?, toParameters parameters: inout Parameters, toMultipart multipart: inout MultipartDict) {
        switch requestPayload {
        case .json(let jsonDict):
            self._mergeJSONDict(jsonDict, prefixKey: prefixKey, toParameters: &parameters, toMultipart: &multipart)
        case .multipart(let formDataArray):
            formDataArray.forEach({
                self._mergeFormData($0, prefixKey: prefixKey, toParameters: &parameters, toMultipart: &multipart)
            })
        case .nested(let key, let payloads):
            let innerPrefixKey: String = self._encodeNestedKeys(outerKey: prefixKey, innerKey: key)
            payloads.forEach({
                self._mergeRequestPayload($0, prefixKey: innerPrefixKey, toParameters: &parameters, toMultipart: &multipart)
            })
        }
    }
    
    func _unwrap() -> UnwrappedRequestPayload {
        var resultParameters: Parameters = [:]
        var resultMultipart: MultipartDict = [:]
        
        self._mergeRequestPayload(self, prefixKey: nil, toParameters: &resultParameters, toMultipart: &resultMultipart)
        
        return resultMultipart.isEmpty ? .parameters(resultParameters) : .multipart(resultMultipart)
    }
}


// MARK: - Array where Element == (String, RequestPayload)
private extension Array where Element == (String, RequestPayload) {
    static func _equals(_ lhs: [Element], _ rhs: [Element]) -> Bool {
        guard lhs.count == rhs.count else { return false }
        for (i, lElement) in lhs.enumerated() {
            guard lElement == rhs[i] else {
                return false
            }
        }
        return true
    }
}


// MARK: -
private extension FormData {
    static func _equals(_ lhs: FormData, _ rhs: FormData) -> Bool {
        switch (lhs, rhs) {
        case (.json(let l), .json(let r)):      return l == r
        case (.image(let l), .image(let r)):    return l == r
        case (.nested(let l), .nested(let r)):  return l == r
        default:                                return false
        }
    }
    
    func _unwrap() -> [String: Data] {
//        switch formData {
//        case .json(let value):
//            result.merge(value.unwrap(), uniquingKeysWith: { _, r in r })
//        case .image(key: let key, image: let image, mimeType: let mimeType):
//            result[key] = {
//                switch mimeType {
//                case .jpeg(let compressionQuality):
//                    return UIImageJPEGRepresentation(image, compressionQuality)
//                case .png:
//                    return UIImagePNGRepresentation(image)
//                }
//            }()
//        case .nested(let value):
//            result.merge(value.mapToDict({ parsePayload($0) }), uniquingKeysWith: { _, r in r})
//        }
        return [:]
    }
    
    //    public func parseMultipart(_ formData: [FormData]) -> Parameters {
    //        var result: Parameters = [:]
    //        for fd in formData {
    //            switch fd {
    //            case .json(let value):
    //                result.merge(value.unwrap(), uniquingKeysWith: { _, r in r })
    //            case .image(key: let key, image: let image, mimeType: let mimeType):
    //                result[key] = {
    //                    switch mimeType {
    //                    case .jpeg(let compressionQuality):
    //                        return UIImageJPEGRepresentation(image, compressionQuality)
    //                    case .png:
    //                        return UIImagePNGRepresentation(image)
    //                    }
    //                }()
    //            case .nested(let value):
    //                result.merge(value.mapToDict({ parsePayload($0) }), uniquingKeysWith: { _, r in r})
    //            }
    //        }
    //        return result
    //    }
}
