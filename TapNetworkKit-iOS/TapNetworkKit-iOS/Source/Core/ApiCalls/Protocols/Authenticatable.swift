//
//  Authenticatable.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal protocol Authenticatable: Decodable {
    
    /// Unique object identifier.
    var identifier: String { get }
    
    /// Charge authentication if required.
    var authentication: Authentication? { get }
    
    /// Authentication route.
    static var authenticationRoute: TapNetworkPath { get }
}


internal protocol AuthorizeProtocol: ChargeProtocol {
    
    /// Authorize action.
    var authorizeAction: AuthorizeActionResponse { get }
}
