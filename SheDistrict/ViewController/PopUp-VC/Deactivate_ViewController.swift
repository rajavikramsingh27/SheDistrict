//
//  Deactivate_ViewController.swift
//  SheDistrict
//
//  Created by appentus on 1/16/20.
//  Copyright © 2020 appentus. All rights reserved.



protocol Delegate_Deactivate {
    func func_Yes_Deactivate()
    func func_No_Deactivate()
}

import UIKit
import KRProgressHUD


class Deactivate_ViewController: UIViewController {
    @IBOutlet weak var lbl_1:UILabel!
    @IBOutlet weak var lbl_2:UILabel!
    
    var str_1 = ""
    var str_2 = ""
    
    var delegate:Delegate_Deactivate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbl_1.text = str_1
        lbl_2.text = str_2
    }
    
    @IBAction func btn_Yes(_ sender:UIButton) {
        if str_1.lowercased().contains("deactive") {
            btn_user_active_deactive()
        } else {
            
        }
        
        func_removeFromSuperview()
        delegate?.func_Yes_Deactivate()
    }
    
    @IBAction func btn_No(_ sender:UIButton) {
        func_removeFromSuperview()
        delegate?.func_No_Deactivate()
    }
    
    func btn_user_active_deactive() {
        let param = ["user_id":signUp!.userID]
        print(param)
        
        let hud = KRProgressHUD.showOn(self)
        hud.show()
        APIFunc.postAPI("user_active_deactive", param) { (json,status,message)  in
            DispatchQueue.main.async {
                hud.dismiss()
                
                let status = return_status(json.dictionaryObject!)
                switch status {
                    case .success:
                        self.funcAlertController(message)
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
                            UserDefaults.standard.removeObject(forKey:k_user_detals)
                            self.func_Next_VC("Login_Option_ViewController")
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
    
}


