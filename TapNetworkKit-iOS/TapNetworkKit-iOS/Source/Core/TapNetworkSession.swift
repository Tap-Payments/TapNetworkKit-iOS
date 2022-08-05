//
//  TapNetworkSession.swift
//  TapNetworkKit-iOS
//
//  Created by Osama Rabie on 04/08/2022.
//  Copyright © 2022 Tap Payments. All rights reserved.
//

import Foundation
import CommonDataModelsKit_iOS

public class TapNetworkSessionConfigurator {
    
    /// Defines the sdk mode of the caller
    public var sdkMode:SDKMode = .sandbox
    /// Defines the tap key of the caller
    public var secretKey:SecretKey = .init(sandbox: "", production: "")
    /// Defines the device id if exists
    public var deviceID:String?
    /// Defines the caller locale identifer
    public var localeIdentifier:String = "en"
    /// Defines the caller sessionToken
    public var sessionToken:String?
    /// Defines the caller MW token
    public var token:String?
    /// Defines the caller card encryptionKey
    public var encryptionKey:String?
    /// Defines the caller wants to enable save card
    public var enableSaveCard:Bool = false
    /// allowed Card Types, if not set all will be accepeted.
    public var allowedCardTypes:[CardType] = [CardType(cardType: .Debit), CardType(cardType: .Credit)]
    /// The server base url
    public var baseURL:URL = URL(string: "https://checkout-mw-java.dev.tap.company/api/")!
    
    
}
