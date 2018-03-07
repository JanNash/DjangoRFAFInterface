//
//  MockFilteredListGettable.swift
//  DjangoRFAFInterfaceTests
//
//  Created by Jan Nash on 24.01.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD 3 Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation
import SwiftyJSON
import SwiftDate
import DjangoConsumer


// MARK: // Internal
// MARK: Struct Declaration
struct MockFilteredListGettable: FilteredListGettable, NeedsNoAuth {
    // Init
    init(id: String, date: Date, name: String) {
        self.id = id
        self.date = date
        self.name = name
    }
    
    // Keys
    struct Keys {
        static let id: String = "id"
        static let date: String = "date"
        static let name: String = "name"
    }
    
    // Variables
    private(set) var id: String = "0"
    private(set) var date: Date = Date()
    private(set) var name: String = "A"
    
    // ListGettable
    init(json: JSON) {
        self.id = json[Keys.id].string!
        self.date = json[Keys.date].string!.date(format: .iso8601(options: .withInternetDateTime))!.absoluteDate
        self.name = json[Keys.name].string!
    }
    
    static var defaultNode: Node = MockNode.main
    static var listGettableClients: [ListGettableClient] = []
}
