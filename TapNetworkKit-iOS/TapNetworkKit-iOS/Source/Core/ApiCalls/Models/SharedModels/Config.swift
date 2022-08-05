//
//  Config.swift
//  CheckoutSDK-iOS
//
//  Created by Osama Rabie on 24/03/2022.
//  Copyright © 2022 Tap Payments. All rights reserved.
//

import Foundation
/// Config part of the Config api request model
internal struct Config: Encodable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal let application: String
    
    // MARK: Methods
    
    internal init(application: String) {
        
        self.application = application
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case application = "application"
    }
}
