//  Friends_List_ViewController.swift
//  SheDistrict
//  Created by appentus on 1/16/20.
//  Copyright © 2020 appentus. All rights reserved.


import UIKit

class Friends_List_ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
}



extension Friends_List_ViewController:UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell-Header") as! Friends_List_Header_TableCell
        
        if section == 0 {
            cell.lbl_header_title.text = "Current Friends List"
        } else {
            cell.lbl_header_title.text = "All Friends"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for:indexPath) as! Friends_List_TableViewCell
        
        if indexPath.section == 0 {
            cell.btn_add_remove.setTitle("Remove", for: .normal)
            cell.btn_add_remove.backgroundColor = UIColor .white
            cell.btn_add_remove.setTitleColor(hexStringToUIColor("4C1D5B"), for: .normal)
        } else {
            cell.btn_add_remove.setTitle("Add", for: .normal)
            cell.btn_add_remove.backgroundColor = hexStringToUIColor("4C1D5B")
            cell.btn_add_remove.setTitleColor(UIColor.white, for: .normal)
        }
        
        return cell
    }

    
    
}
