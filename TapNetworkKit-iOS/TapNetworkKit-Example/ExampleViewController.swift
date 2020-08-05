//
//  ExampleViewController.swift
//  TapNetworkKit-Example
//
//  Created by Kareem Ahmed on 8/5/20.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import UIKit
import TapNetworkKit_iOS

class ExampleViewController: UIViewController {

    let apiKey = "BWGjm2yyorId0byBKTPtGp0AmJScFYM8"
    override func viewDidLoad() {
        super.viewDidLoad()
//        testSuccessful()
        testErrorWithoutModel()
    }
    
    func testSuccessful() {
        let manager = TapNetworkManager(baseURL: URL(string: "https://api.nytimes.com/svc/")!)
        manager.isRequestLoggingEnabled = true
        let requestOperation = TapNetworkRequestOperation(path: "topstories/v2/world.json?api-key=\(apiKey)", method: .GET, headers: nil, urlModel: .none, bodyModel: .none, responseType: .json)
            
        manager.performRequest(requestOperation, completion: { (session, list, error) in
            print("list is: \(list)")
            print("error: \(error)")

        }, codableType: StoriesResponse.self)
    }
    
    func testErrorHandlingWithModel() {
        let manager = TapNetworkManager(baseURL: URL(string: "https://api.nytimes.com/svc/")!)
        manager.isRequestLoggingEnabled = true
        let requestOperation = TapNetworkRequestOperation(path: "topstories/v2/world.json?api-key=\(apiKey)ss", method: .GET, headers: nil, urlModel: .none, bodyModel: .none, responseType: .json)
            
        manager.performRequest(requestOperation, completion: { (session, list, error) in
            print("list is: \(list)")
            print("error: \(error)")

        }, codableType: StoriesError.self)
    }
    
    func testErrorWithoutModel() {
        let manager = TapNetworkManager(baseURL: URL(string: "https://api.nytimes.comssssw/svc/")!)
        manager.isRequestLoggingEnabled = true
        let requestOperation = TapNetworkRequestOperation(path: "topstories/v2/world.json?api-key=\(apiKey)", method: .GET, headers: nil, urlModel: .none, bodyModel: .none, responseType: .json)
            
        manager.performRequest(requestOperation, completion: { (session, list, error) in
            print("list is: \(list)")
            print("error: \(error?.localizedDescription)")

        }, codableType: StoriesResponse.self)
    }

    
}
