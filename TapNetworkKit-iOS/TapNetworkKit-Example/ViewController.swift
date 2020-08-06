//
//  ViewController.swift
//  TapNetworkKit-Example
//
//  Created by Kareem Ahmed on 8/5/20.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    lazy var dataSource:[[String:Any]] = []
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.append(["title":"Successful get request without headers","subtitle":"Displays successfull request test","navigationID":"ExampleViewController","push":"1", "requestType": TestCaseType.successGetRequestWithoutHeaders])
        dataSource.append(["title":"Failed get request without headers with error model","subtitle":"Displays successfull request test","navigationID":"ExampleViewController","push":"1", "requestType": TestCaseType.failedGetRequestWithoutHeadersWithErrorModel])

        tableView.dataSource = self
        tableView.delegate = self
    }


}


extension ViewController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tapUIKitCell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]["title"] as? String
        cell.detailTextLabel?.text = dataSource[indexPath.row]["subtitle"] as? String
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let destnationVC = (storyboard?.instantiateViewController(withIdentifier: dataSource[indexPath.row]["navigationID"]! as! String))! as! ExampleViewController
//        (storyboard?.instantiateViewController(identifier: dataSource[indexPath.row]["navigationID"]! as! String))! as ExampleViewController destnationVC.title = dataSource[indexPath.row]["title"] as? String
        destnationVC.requestTestCase = dataSource[indexPath.row]["requestType"] as? TestCaseType
            showController(contoller: destnationVC, push: dataSource[indexPath.row]["push"] as! String == "1")
    }
    
    func showController(contoller:UIViewController, push:Bool) {
        if push {
            navigationController?.pushViewController(contoller, animated: true)
        }else {
            present(contoller, animated: true, completion: nil)
        }
    }
    
}

