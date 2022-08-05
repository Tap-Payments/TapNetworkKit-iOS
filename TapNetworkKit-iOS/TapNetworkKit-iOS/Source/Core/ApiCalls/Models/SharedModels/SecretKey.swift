//
//  SecretKey.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// The model that represents the Secret key providede to your app bunlde from TAP
/// - tag: SecretKey
@objcMembers public final class SecretKey: NSObject {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Sandbox secret key.
    public let sandbox: String
    
    /// Production secret key.
    public let production: String
    
    /// The used key based on the  selected mode production or sandbox
    internal var usedKey:String {
        switch NetworkManager.networkSessionConfigurator.sdkMode {
        case .production:
            return production
        case .sandbox:
            return sandbox
        }
    }
    
    // MARK: Methods
    
    /// Initializes secret key with sandbox and production keys.
    ///
    /// - Parameters:
    ///   - sandbox: Sandbox key.
    ///   - production: Production key.
    public required init(sandbox: String, production: String) {
        
        self.sandbox    = sandbox
        self.production = production
        
        super.init()
    }
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal static let empty: SecretKey = SecretKey(sandbox: .tap_empty, production: .tap_empty)
}
