//  Report_Resion_ViewController.swift
//  SheDistrict
//  Created by appentus on 1/8/20.
//  Copyright © 2020 appentus. All rights reserved.



protocol Delegate_Report_Resion {
    func func_select_resion()
}


import UIKit
import KRProgressHUD


class Report_Resion_ViewController: UIViewController {
    var delegate:Delegate_Report_Resion?
    
    var friend_id = ""
    
    var arr_resion = ["She's harassing me",
                      "She's annoying",
                      "Wants to meet too soon",
                      "I think her profile is fake",
                      "She’s being inappropriate"]
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func btn_cancel(_ sender:UIButton) {
        func_removeFromSuperview()
    }

    
    
}



extension Report_Resion_ViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_resion.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"cell", for: indexPath)
        
        let lbl_resion = cell.viewWithTag(1) as? UILabel
        let btn_select_resion = cell.viewWithTag(2) as? UIButton
        
        lbl_resion!.text = arr_resion[indexPath.row]
        
        if btn_select_resion != nil {
            btn_select_resion!.tag = indexPath.row
            btn_select_resion!.addTarget(self, action: #selector(btn_select_resion(_:)), for:.touchUpInside)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    @IBAction func btn_select_resion(_ sender:UIButton) {
        func_API_user_report(arr_resion[sender.tag])
    }
        
    func func_API_user_report(_ reason:String) {
        let hud = KRProgressHUD.showOn(self)
        hud.show()
                
        let param = ["user_id":"\(signUp!.userID)",
                    "friend_id":friend_id,
                    "reason":reason]
        print(param)
        
        APIFunc.postAPI("user_report", param) { (json,status,message) in
            DispatchQueue.main.async {
                hud.dismiss()
                
//                let status = return_status(json.dictionaryObject!)
                switch status {
                case success_resp:
                    self.func_removeFromSuperview()
                    self.delegate?.func_select_resion()
                case failed_resp:
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                        hud.showError(withMessage: "\(json["message"])")
                    })
                default:
                    break
                }
            }
        }
    }
    
}
