//
//  ViewController.swift
//  TapNetworkKit-Example
//
//  Created by Kareem Ahmed on 8/5/20.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    lazy var dataSource:[[String:String]] = []
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.append(["title":"Successful request test","subtitle":"Displays successfull request test","navigationID":"ExampleViewController","push":"1"])

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
        cell.textLabel?.text = dataSource[indexPath.row]["title"]
        cell.detailTextLabel?.text = dataSource[indexPath.row]["subtitle"]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let destnationVC:UIViewController = storyboard?.instantiateViewController(withIdentifier: dataSource[indexPath.row]["navigationID"]!) {
            destnationVC.title = dataSource[indexPath.row]["title"]
            showController(contoller: destnationVC, push: dataSource[indexPath.row]["push"] == "1")

        }
    }
    
    func showController(contoller:UIViewController, push:Bool) {
        if push {
            navigationController?.pushViewController(contoller, animated: true)
        }else {
            present(contoller, animated: true, completion: nil)
        }
    }
    
}

