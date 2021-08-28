//
//  Latest_Posts_ViewController.swift
//  SheDistrict
//
//  Created by appentus on 1/15/20.
//  Copyright © 2020 appentus. All rights reserved.
//

import UIKit

class Latest_Posts_ViewController: UIViewController {
    @IBOutlet weak var tbl_latest_posts:UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tbl_latest_posts.reloadData()
    }
    
}



extension Latest_Posts_ViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 106
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"cell", for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration:0.25, delay:0.01, animations: {
            cell.alpha = 1
        })
    }
    
}


