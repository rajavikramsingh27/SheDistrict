//  Purchases_ViewController.swift
//  SheDistrict
//  Created by appentus on 1/17/20.
//  Copyright © 2020 appentus. All rights reserved.


import UIKit


class Purchases_ViewController: UIViewController {
    
    let arr_plan_icon = ["Shape_1.png","Shape_2.png","Shape_3.png",]
    let arr_plan_price = ["$ 5.99","$ 9.99","$ 24.99"]
    let arr_plan_time = ["1 Month","6 Months","1 year"]
    let arr_boosts = ["2 Boosts","4 Boosts","6 Boosts","10 Boosts"]
    let arr_boosts_price = ["$ 0.99","$ 1.99","$ 2.99","$ 4.99"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
}



extension Purchases_ViewController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < 4 { // cell plan
            return 74
        } else if indexPath.row == 4 { // cell-1
            return 90
        } else {
            return 60 // cell boosts
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell-plan", for: indexPath) as! Purchase_Plan_TableViewCell
            if indexPath.row < 3 {
                cell.img_plan_icon.image = UIImage (named:arr_plan_icon[indexPath.row])
                
                cell.view_plan_color.backgroundColor = UIColor .clear
                cell.lbl_price.textColor = UIColor .white
                cell.lbl_plan_time.textColor = UIColor .white
                
                cell.lbl_price.text = arr_plan_price[indexPath.row]
                cell.lbl_plan_time.text = arr_plan_time[indexPath.row]
            } else {
                cell.img_plan_icon.image = UIImage (named:"")
                
                cell.view_plan_color.backgroundColor = UIColor .lightGray.withAlphaComponent(0.2)
                cell.lbl_price.textColor = hexStringToUIColor("4C1D5B")
                cell.lbl_plan_time.textColor = hexStringToUIColor("4C1D5B")
                
                cell.lbl_price.text = "$ 199.99"
                cell.lbl_plan_time.text = "All-Access"
            }
            return cell
        } else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell-1", for: indexPath)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell-boosts", for: indexPath) as! Purchase_Boosts_TableViewCell
            
            cell.lbl_boosts.text = arr_boosts[indexPath.row-5]
            cell.lbl_price.text = arr_boosts_price[indexPath.row-5]
            
            return cell
        }
    }
    
    
}
