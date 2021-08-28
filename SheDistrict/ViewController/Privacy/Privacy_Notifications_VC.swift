//  Privacy_Notifications_VC.swift
//  SheDistrict
//  Created by appentus on 1/16/20.
//  Copyright © 2020 appentus. All rights reserved.


import UIKit
import KRProgressHUD


class Privacy_Notifications_VC: UIViewController {
    @IBOutlet weak var switchPushNotification:UISwitch!
    @IBOutlet var buttonNotification:[UIButton]!
    
    var pushSetting = [String:Any]()
    var pushSettingNew = [String:Any]()
    
    var push_status = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switchPushNotification.isOn = signUp!.pushStatus == "0" ? false : true
        pushSetting = signUp!.pushSetting.dictionary
        print(pushSetting)
        
        for i in 1...buttonNotification.count {
            pushSettingNew["\(i)"] = "0"
            
            for (key,value) in pushSetting {
                if "\(value)".isEmpty {
                    pushSetting[key] = "0"
                } else {
                    pushSetting[key] = value
                }
            }
            
            buttonNotification[i-1].tag = i
            buttonNotification[i-1].isSelected = "\(pushSetting["\(i)"] ?? "0")" == "0" ? false : true
            buttonNotification[i-1].addTarget(self, action: #selector(buttonNotification(_:)), for: .touchUpInside)
        }
        
        if pushSetting.count == 0 {
            pushSetting = pushSettingNew
        }
        print(pushSetting)
    }
    
    @IBAction func switchPushNotification(_ sender:UISwitch) {
        push_status = sender.isOn ? "1" : "0"
        func_API_update_notification_setting(sender.tag)
    }
    
    @IBAction func buttonNotification(_ sender:UIButton) {
        let isButtonSelected = !sender.isSelected
        pushSetting["\(sender.tag)"] = isButtonSelected ? "1" : "0"
        print(pushSetting)
        func_API_update_notification_setting(sender.tag)
    }
    
    func func_API_update_notification_setting(_ tag:Int) {
        let hud = KRProgressHUD.showOn(self)
        hud.show()
        
        let param = ["user_id":signUp!.userID,
                     "push_setting":pushSetting.json,
                    "push_status":push_status]
        print(param)
        
        APIFunc.postAPI("update_notification_setting", param) { (json,status,message) in
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
                            if tag > 0 {
                                self.buttonNotification[tag-1].isSelected = !self.buttonNotification[tag-1].isSelected
                            }
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
