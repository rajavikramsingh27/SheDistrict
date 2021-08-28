//  Privacy_Profile_VC.swift
//  SheDistrict
//  Created by appentus on 1/16/20.
//  Copyright © 2020 appentus. All rights reserved.


import UIKit
import KRProgressHUD


class Privacy_Profile_VC: UIViewController {
    @IBOutlet var switches:[UISwitch]!
    
    var hide_profile = ""
    var hide_activity = ""
    var stop_invite = ""
    var hide_location = ""
    var hide_age = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0..<switches.count {
            let switchButton = switches[i]
            switchButton.tag = i
            switchButton.addTarget(self, action:#selector(btnSwitch(_:)), for:.valueChanged)
        }
        funcSetUI()
    }
        
    func funcSetUI() {
        hide_profile = signUp?.hideProfile ?? "0"
        hide_activity = signUp?.hideActivity ?? "0"
        stop_invite = signUp?.stopInvite ?? "0"
        hide_location = signUp?.hideLocation ?? "0"
        hide_age = signUp?.hideAge ?? "0"
                
        switches[0].isOn = hide_profile == "1" ? true : false
        switches[1].isOn = hide_activity == "1" ? true : false
        switches[2].isOn = stop_invite == "1" ? true : false
        switches[3].isOn = hide_location == "1" ? true : false
        switches[4].isOn = hide_age == "1" ? true : false
    }
    
    @IBAction func btnSwitch(_ sender:UISwitch) {
        if sender.tag == 0 {
            let isOn = sender.isOn ? "1" : "0"
            hide_profile = isOn
        } else if sender.tag == 1 {
            let isOn = sender.isOn ? "1" : "0"
            hide_activity = isOn
        } else if sender.tag == 2 {
            let isOn = sender.isOn ? "1" : "0"
            stop_invite = isOn
        } else if sender.tag == 3 {
            let isOn = sender.isOn ? "1" : "0"
            hide_location = isOn
        } else if sender.tag == 4 {
            let isOn = sender.isOn ? "1" : "0"
            hide_age = isOn
        }
        
        func_update_profile_setting()
    }
    
    @IBAction func btn_delete_account(_ sender:UIButton) {
        func_Deactivate("Are you sure you want to delete", "your profile?")
    }
    
    @IBAction func btn_deactivate_account(_ sender:UIButton) {
        func_Deactivate("Are you sure you want to deactivate", "your profile?")
    }
    
     func func_Deactivate(_ str_1:String,_ str_2:String) {
        let storyboard = UIStoryboard (name: "PopUp", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Deactivate_ViewController") as! Deactivate_ViewController
        vc.str_1 = str_1
        vc.str_2 = str_2
        
        self.addChild(vc)
        
        vc.view.transform = CGAffineTransform(scaleX:2, y:2)
        
        self.view.addSubview(vc.view)
        UIView.animate(withDuration:0.2, delay: 0, usingSpringWithDamping:0.7, initialSpringVelocity: 0, options: [],  animations: {
            vc.view.transform = .identity
        })
    }
    
    func func_update_profile_setting() {
        let param = ["hide_profile":hide_profile,
                    "hide_activity":hide_activity,
                    "stop_invite":stop_invite,
                    "hide_location":hide_location,
                    "hide_age":hide_age,
                    "user_id":signUp!.userID]
        print(param)
        
        let hud = KRProgressHUD.showOn(self)
        hud.show()
        APIFunc.postAPI("update_profile_setting", param) { (json,status,message) in
            DispatchQueue.main.async {
                hud.dismiss()
                
                let status = return_status(json.dictionaryObject!)
                switch status {
                case .success:
                    let decoder = JSONDecoder()
                    if let jsonData = json[result_resp].description.data(using: .utf8) {
                        do {
                            signUp = try decoder.decode(SignUp.self, from: jsonData)
                            let data = try json.rawData()
                            UserDefaults.standard.setValue(data, forKey: k_user_detals)
                            self.funcSetUI()
                        } catch {
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                                hud.showError(withMessage: "\(error.localizedDescription)")
                            })
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
    
}


