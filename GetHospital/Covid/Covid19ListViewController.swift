//
//  Covid-19ListViewController.swift
//  GetHospital
//
//  Created by Chaithra Shrikrishna on 16/07/20.
//  Copyright © 2020 Chaithra Shrikrishna. All rights reserved.
//

import UIKit
import Alamofire

class Covid19ListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var data: NSDictionary?
    var allStates = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCovidDetails(url: "https://api.covid19india.org/state_district_wise.json", completionHandler: { [weak self] (result) in
            self?.data = result
            self?.allStates = result.allKeys as! [String]
            self?.tableView.reloadData()
        }) { (error) in
            
        }
        
    
        
    }
    
    func fetchCovidDetails (url: String, completionHandler: @escaping (NSDictionary) -> Void, failureHandler: @escaping (Result<NetworkError>) -> Void) {
        let networkOp = NetworkOperation<CovidDetails>()
        networkOp.performOperation(url, type: .get, completionHandler: { (result) in
            completionHandler(result)
        }) { (error) in
            failureHandler(error)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showDetail" {
            // Get the single item.
            guard let selectedItemPath = tableView.indexPathForSelectedRow else { return }
            let state = allStates[selectedItemPath.row]
            
        }
    }
}

extension Covid19ListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allStates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = allStates[indexPath.row]
        return cell
    }
}
