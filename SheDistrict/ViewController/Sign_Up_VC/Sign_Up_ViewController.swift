//  Sign_Up_ViewController.swift
//  SheDistrict
//  Created by appentus on 1/3/20.
//  Copyright © 2020 appentus. All rights reserved.


import UIKit
import DropDown
import UIView_Shake
import KRProgressHUD
import CoreLocation


class Sign_Up_ViewController: UIViewController {
    @IBOutlet var img_icon:[UIImageView]!
    @IBOutlet var tick_icon:[UIImageView]!
    @IBOutlet var view_field:[UIView]!
    @IBOutlet var text_field:[UITextField]!
    @IBOutlet var text_field_date:[UITextField]!
    
    let arr_img_icon_selected = ["Email.png","User.png","Lock.png","Phone.png"]
    let arr_img_icon_unselected = ["Email_g.png","User_g.png","Lock_g.png","Phone_g.png"]
     
    let date_picker_view = UIDatePicker()
    
    var co_OrdinateCurrent = CLLocationCoordinate2DMake(0.0, 0.0)
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        func_core_location()
        
        date_picker_view.addTarget(self, action: #selector(func_date_picker(_:)), for: .valueChanged)
        date_picker_view.datePickerMode = .date
        
        for i in 0..<text_field_date.count {
            text_field_date[i].tag = i+5
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        arr_create_profile_fields = [Bool]()
        user_intro = nil
        user_bio_text = ""
        user_bio_image = nil
        user_bio_video = nil
    }
    
    private func func_validation() -> Bool {
        var is_valid = false
        for i in 0..<text_field.count-1 {
            if text_field[i].text!.isEmpty {
                view_field[i].shake()
                view_field[i].func_error_shadow()
                
                is_valid = false
                break
            } else {
                if !text_field[0].text!.isValidEmail() {
                    view_field[0].shake()
                    view_field[0].func_error_shadow()
                    
                    is_valid = false
                    break
                } else if text_field[2].text!.count < 6 && !text_field[2].text!.isEmpty {
                    view_field[2].shake()
                    view_field[2].func_error_shadow()
                    KRProgressHUD.showError(withMessage: "Password minimum length should be 6 digits.")
                    break
                }
                
                view_field[i].func_success_shadow()
                is_valid = true
            }
        }
        
        return is_valid
    }
    
    @IBAction func btn_next(_ sender:UIButton) {
        self.view.endEditing(true)
            
        if !func_validation() {
            return
        }
        
        let param = [
            "email":text_field[0].text!,
            "name":text_field[1].text!,
            "password":text_field[2].text!,
            "mobile":text_field[3].text!,
            "device_type":"2",
            "device_token":k_FireBaseFCMToken,
            "user_lat":"\(co_OrdinateCurrent.latitude)",
            "user_lang":"\(co_OrdinateCurrent.longitude)",
        ]
        print(param)
        
        let hud = KRProgressHUD.showOn(self)
        hud.show()
        APIFunc.postAPI("user_signup", param) { (json,status,message) in
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
                                self.func_Next_VC_Main_1("TabBar_SheDistrict")
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
    
    @IBAction func func_date_picker(_ sender:UIDatePicker) {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd-MMMM-yyyy"
        let selected_date = dateformatter.string(from:sender.date)
        
        let arr_selected_date = selected_date.components(separatedBy: "-")
        for i in 0..<text_field_date.count {
            text_field_date[i].text = arr_selected_date[i]
        }
    }
    
}



extension Sign_Up_ViewController:UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        for view in view_field {
            view.func_success_shadow()
        }
        
        for i in 0..<img_icon.count {
            if i+1 == textField.tag {
                img_icon[i].image = UIImage (named:arr_img_icon_selected[textField.tag-1])
                tick_icon[i].image = UIImage (named: "Check.png")
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        for i in 0..<text_field.count {
            if i+1 == textField.tag {
                if text_field[i].text!.isEmpty {
                    img_icon[i].image = UIImage (named:arr_img_icon_unselected[textField.tag-1])
                    tick_icon[i].image = UIImage (named: "Check_g.png")
                } else {
                    img_icon[i].image = UIImage (named:arr_img_icon_selected[textField.tag-1])
                    tick_icon[i].image = UIImage (named: "Check.png")
                    
                    if !text_field[0].text!.isValidEmail() {
                        img_icon[0].image = UIImage (named:arr_img_icon_unselected[textField.tag-1])
                        tick_icon[0].image = UIImage (named: "Check_g.png")
                    }
                }
            }
        }
    }
    
}

extension Sign_Up_ViewController:CLLocationManagerDelegate {
    func func_core_location() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        co_OrdinateCurrent = manager.location!.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}
