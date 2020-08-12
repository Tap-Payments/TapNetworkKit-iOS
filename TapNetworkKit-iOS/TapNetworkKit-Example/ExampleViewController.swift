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
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    public var requestTestCase: TestCaseType?

    let apiKey = "BWGjm2yyorId0byBKTPtGp0AmJScFYM8"
    override func viewDidLoad() {
        super.viewDidLoad()
        Logger.log(event: "test", value: ["check": "value"])

        switch requestTestCase {
        case .successGetRequestWithoutHeaders:
            successGetRequestWithoutHeaders()
        case .failedGetRequestWithoutHeadersWithErrorModel:
            failedGetRequestWithoutHeadersWithErrorModel()
        case .failedGetRequestWithoutHeadersWithoutErrorModel:
            failedGetRequestWithoutHeadersWithoutErrorModel()
        case .successPostRequestWithHeaders:
            successPostRequestWithHeaders()
        default:
            break
        }
    }
    
    // MAEK: Requests
    func successGetRequestWithoutHeaders() {
        let manager = TapNetworkManager(baseURL: URL(string: "https://api.nytimes.com/svc/")!)
        manager.isRequestLoggingEnabled = true
        let requestOperation = TapNetworkRequestOperation(path: "topstories/v2/world.json?api-key=\(apiKey)", method: .GET, headers: nil, urlModel: .none, bodyModel: .none, responseType: .json)
        
        manager.performRequest(requestOperation, completion: { (session, result, error) in
            print("result is: \(String(describing: result))")
            print("error: \(String(describing: error))")
            self.statusLabel.text = (error != nil) ? "Error: \(String(describing: error))" : "Success"
            guard let stories = result as? StoriesResponse, let storiesResults = stories.results else { return }
            let storiesTitles = storiesResults.compactMap { "Title: \($0.title ?? "No title!")" }
            self.resultLabel.text = storiesTitles.joined(separator: "\n")
        }, codableType: StoriesResponse.self)
    }
    
    func failedGetRequestWithoutHeadersWithErrorModel() {
        let manager = TapNetworkManager(baseURL: URL(string: "https://api.nytimes.com/svc/")!)
        manager.isRequestLoggingEnabled = true
        let requestOperation = TapNetworkRequestOperation(path: "topstories/v2/world.json?api-key=\(apiKey)ss", method: .GET, headers: nil, urlModel: .none, bodyModel: .none, responseType: .json)
            
        manager.performRequest(requestOperation, completion: { (session, list, error) in
            print("list is: \(String(describing: list))")
            print("error: \(String(describing: error))")
            self.statusLabel.text = (error != nil) ? "Error: \(String(describing: error))" : "Success"

        }, codableType: StoriesError.self)
    }
    
    func failedGetRequestWithoutHeadersWithoutErrorModel() {
        let manager = TapNetworkManager(baseURL: URL(string: "https://api.nytimes.comssssw/svc/")!)
        manager.isRequestLoggingEnabled = true
        let requestOperation = TapNetworkRequestOperation(path: "topstories/v2/world.json?api-key=\(apiKey)", method: .GET, headers: nil, urlModel: .none, bodyModel: .none, responseType: .json)
            
        manager.performRequest(requestOperation, completion: { (session, list, error) in
            print("list is: \(String(describing: list))")
            print("error: \(String(describing: error?.localizedDescription))")
            self.statusLabel.text = (error != nil) ? "Error: \(String(describing: error))" : "Success"

        }, codableType: StoriesResponse.self)
    }
    
    func successPostRequestWithHeaders() {
        let manager = TapNetworkManager(baseURL: URL(string: "https://api.thecatapi.com/v1/")!)
        manager.isRequestLoggingEnabled = true
        let body = TapBodyModel(body: ["image_id": "asf2",
                                       "sub_id": "my-user-1234",
                                       "value": 1])

        let requestOperation = TapNetworkRequestOperation(path: "votes", method: .POST, headers: ["x-api-key":"bc7ffba5-a22b-4bee-b956-5c6d8192be7a"], urlModel: .none, bodyModel: body, responseType: .json)
            
        manager.performRequest(requestOperation, completion: { (session, result, error) in
            print("result is: \(String(describing: result))")
            print("error: \(String(describing: error?.localizedDescription))")
            self.statusLabel.text = (error != nil) ? "Error: \(String(describing: error))" : "Success"
            guard let vote = result as? VoteSuccess else { return }
            self.resultLabel.text = "id: \(vote.id) \nmessage: \(vote.message)"
            
        }, codableType: VoteSuccess.self)
        
    }
    
    

    
}
