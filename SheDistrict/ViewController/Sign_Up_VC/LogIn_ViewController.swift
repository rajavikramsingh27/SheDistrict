//  Log_In_ViewController.swift
//  SheDistrict
//  Created by appentus on 1/4/20.
//  Copyright © 2020 appentus. All rights reserved.


import UIKit
import KRProgressHUD


class Log_In_ViewController: UIViewController {
    @IBOutlet var view_field:[UIView]!
    @IBOutlet var img_icon:[UIImageView]!
    @IBOutlet var text_field:[UITextField]!
    @IBOutlet weak var btn_remember:UIButton!
    
    let arr_img_icon_selected = ["User.png","Lock.png","Phone.png"]
    let arr_img_icon_unselected = ["User_g.png","Lock_g.png","Phone_g.png"]
    
    let date_picker_view = UIDatePicker()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func btn_remember(_ sender:UIButton) {
        btn_remember.isSelected = !btn_remember.isSelected
    }
    
    @IBAction func btn_next(_ sender:UIButton) {
        self.view.endEditing(true)
        if !func_validation() {
            return
        }
        
        let param = [
            "user_email":text_field[0].text!,
            "user_password":text_field[1].text!,
            "device_type":"2",
            "device_token":k_FireBaseFCMToken
        ]
            
        print(param)
        
        let hud = KRProgressHUD.showOn(self)
        hud.show()
        APIFunc.postAPI("user_login", param) { (json,status,message) in
            DispatchQueue.main.async {
                hud.dismiss()
                
                let status = return_status(json.dictionaryObject!)
                switch status {
                case .success:
                    let decoder = JSONDecoder()
                    if let jsonData = json[result_resp].description.data(using: .utf8) {
                        do {
                            signUp = try decoder.decode(SignUp.self, from: jsonData)
                            if (signUp?.userDetails[0].userBio.isEmpty)! && (signUp?.userDetails[0].userBioImage.isEmpty)! && (signUp?.userDetails[0].userBioVideo.isEmpty)! && (signUp?.userDetails[0].userIntroVideo.isEmpty)! {
                                self.func_Next_VC("Create_Your_Profile_VC")
                            } else {
                                let data = try json.rawData()
                                UserDefaults.standard.setValue(data, forKey: k_user_detals)
                                self.func_Next_VC_Main_1("TabBar_SheDistrict")
                            }
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
    
    
    
    private func func_validation() -> Bool {
        var is_valid = false
        for i in 0..<text_field.count {
            if text_field[i].text!.isEmpty {
                view_field[i].shake()
                view_field[i].func_error_shadow()
                
                is_valid = false
                break
            } else {
                 if text_field[1].text!.count < 6 && !text_field[1].text!.isEmpty {
                    view_field[1].shake()
                    view_field[1].func_error_shadow()
                    KRProgressHUD.showError(withMessage: "Password minimum length should be 6 digits.")
                    break
                }
                
                view_field[i].func_success_shadow()
                is_valid = true
            }
        }
        return is_valid
    }
    
}



extension Log_In_ViewController:UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        for view in view_field {
            view.func_success_shadow()
        }
        
        for i in 0..<img_icon.count {
            if i+1 == textField.tag {
                img_icon[i].image = UIImage (named:arr_img_icon_selected[textField.tag-1])
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        for i in 0..<text_field.count {
            if i+1 == textField.tag {
                if text_field[i].text!.isEmpty {
                    img_icon[i].image = UIImage (named:arr_img_icon_unselected[textField.tag-1])
                } else {
                    img_icon[i].image = UIImage (named:arr_img_icon_selected[textField.tag-1])
                }
            }
        }
    }
    
}


