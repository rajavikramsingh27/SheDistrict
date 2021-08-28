//  She_Rules_ViewController.swift
//  SheDistrict
//  Created by appentus on 1/4/20.
//  Copyright © 2020 appentus. All rights reserved.


import UIKit
import KRProgressHUD


class She_Rules_ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var btn_selected:UIButton!
    @IBOutlet weak var tbl_she_rules:UITableView!
    
    var is_check = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        func_unselected()
        
        let hud = KRProgressHUD.showOn(self)
        hud.show()
        APIFunc.getAPI("she_rules", [:]) { (json,status,message) in
            DispatchQueue.main.async {
                hud.dismiss()
                
                let status = return_status(json.dictionaryObject!)
                switch status {
                case .success:
                    let decoder = JSONDecoder()
                    if let jsonData = json[result_resp].description.data(using: .utf8) {
                        do {
                            sheRules = try decoder.decode([SheRules].self, from: jsonData)
                            for i in 0..<sheRules.count{
                                sheRules[i].ruleTitle = sheRules[i].ruleTitle.htmlToAttributedString!.string
                                sheRules[i].ruleDiscription = sheRules[i].ruleDiscription.htmlToAttributedString!.string
                            }
                            self.tbl_she_rules.reloadData()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                case .fail:
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                        hud.showError(withMessage: "\(json["message"])")
                    })
                case .error_from_api:
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                        hud.showError(withMessage:"error_message")
                    })
                }
            }
        }
    }
    
    @IBAction func btn_next(_ sender:UIButton) {
        if !is_check {
            KRProgressHUD.showError(withMessage:"Please agree with the rules!")
            return
        }
        func_Next_VC_Main_1("TabBar_SheDistrict")
    }
    
    @IBAction func btn_selected(_ sender:UIButton) {
        if btn_selected.isSelected {
            func_unselected()
            is_check = false
            btn_selected.isSelected = false
        } else {
            func_selected()
            is_check = true
            btn_selected.isSelected = true
        }
    }
        
    func func_unselected() {
        btn_selected.backgroundColor = UIColor .white
        btn_selected.layer.cornerRadius = btn_selected.bounds.height/2
        btn_selected.layer.borderColor = hexStringToUIColor("7F8DF1") .cgColor
        btn_selected.layer.borderWidth = 1
        btn_selected.clipsToBounds = true
    }
    
    func func_selected() {
        btn_selected.backgroundColor = hexStringToUIColor("7F8DF1")
        btn_selected.layer.cornerRadius = btn_selected.bounds.height/2
        btn_selected.layer.borderColor = hexStringToUIColor("7F8DF1") .cgColor
        btn_selected.layer.borderWidth = 1
        btn_selected.clipsToBounds = true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let ruleDiscription = sheRules[indexPath.row].ruleDiscription //.htmlToAttributedString?.string
        return height_according_to_text(ruleDiscription, UIFont(name: "Roboto-Light", size:16.0)!)+50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sheRules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for:indexPath)
        
        let lbl_header = cell.viewWithTag(1) as! UILabel
        let lbl_description = cell.viewWithTag(2) as! UILabel
        
        let ruleTitle = sheRules[indexPath.row].ruleTitle //.htmlToAttributedString?.string
        lbl_header.text = "\(indexPath.row+1) "+ruleTitle
        lbl_description.text = sheRules[indexPath.row].ruleDiscription //.htmlToAttributedString?.string
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        
        UIView.animate(withDuration:0.25, delay:0.01,animations: {
            cell.alpha = 1
        })
    }
    
}




