//
//  NoAuthNode.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 28.04.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//


// MARK: // Public
// MARK: Protocol Declaration
public protocol NoAuthNode: Node {
    var sessionManagerNoAuth: SessionManagerType { get }
}
