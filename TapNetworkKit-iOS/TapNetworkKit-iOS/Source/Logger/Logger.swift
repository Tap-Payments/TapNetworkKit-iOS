//
//  Logger.swift
//  TapNetworkKit-iOS
//
//  Created by Kareem Ahmed on 8/12/20.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import Foundation

@objc public class Logger: NSObject {
    @objc public class func log(event: String, value: [String: Any]) {
        let manager = TapNetworkManager(baseURL: URL(string: "https://api.nytimes.com/svc/")!)
        manager.isRequestLoggingEnabled = true
        let requestOperation = TapNetworkRequestOperation(path: "", method: .GET, headers: nil, urlModel: .none, bodyModel: .none, responseType: .json)
        
        manager.performRequest(requestOperation, completion: { (session, result, error) in
            print("result is: \(String(describing: result))")
            print("error: \(String(describing: error))")
            
        })
    }
}
