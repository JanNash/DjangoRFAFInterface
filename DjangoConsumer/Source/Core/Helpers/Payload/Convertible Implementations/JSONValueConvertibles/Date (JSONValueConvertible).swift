//
//  Date (JSONValueConvertible).swift
//  DjangoConsumer
//
//  Created by Jan Nash on 22.07.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation


// MARK: // Public
extension Date: JSONValueConvertible {
    public func toJSONValue() -> Payload.JSON.Value {
        return self._toJSONValue()
    }
}


// MARK: // Private
private extension Date/*: JSONValueConvertible */ {
    func _toJSONValue() -> Payload.JSON.Value {
        guard #available(iOS 11, *) else {
            // FIXME:
            return .string("")
        }
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return .string(formatter.string(from: self))
    }
}
