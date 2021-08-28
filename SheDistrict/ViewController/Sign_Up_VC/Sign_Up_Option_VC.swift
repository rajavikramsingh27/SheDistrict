//  Sign_Up_ViewController.swift
//  SheDistrict
//  Created by appentus on 1/3/20.
//  Copyright © 2020 appentus. All rights reserved.


import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import KRProgressHUD
import CoreLocation



class Sign_Up_Option_VC: UIViewController {
   // @IBOutlet weak var btn_login:UIButton!
    let fbLoginManager : LoginManager = LoginManager()
    
    var co_OrdinateCurrent = CLLocationCoordinate2DMake(0.0, 0.0)
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        
        
        let color_1 = UIColor .black
        let color_2 = hexStringToUIColor("F71E5A")
        
        let font_1 = UIFont (name: "Roboto", size: 18.0)
        
      //  btn_login.setAttributedTitle(func_attributed_text(color_1, color_2, font_1!, font_1!,"Already have an account? ", "Log In"), for: .normal)
        
        func_core_location()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @IBAction func btn_email(_ sender:Any) {
        func_Next_VC("Sign_Up_ViewController")
    }
    
    @IBAction func btn_login(_ sender:Any) {
        func_Next_VC_Main_1("Log_In_ViewController")
    }
    
    
}



extension Sign_Up_Option_VC {
    @IBAction func btn_fb_login(_ sender: UIButton) {
        func_facebook()
    }
    
    func func_facebook() {
        self.view.endEditing(true)
        let deletepermission = GraphRequest(graphPath: "me/permissions/", parameters: [:], httpMethod: HTTPMethod(rawValue: "DELETE"))
        deletepermission.start(completionHandler: {(connection,result,error)-> Void in
            print("the delete permission is \(result ?? "")")
        })
        
        fbLoginManager.logIn(permissions: ["email"], from: self) { (result, error) -> Void in
            DispatchQueue.main.async {
                if (error == nil) {
                    let fbloginresult : LoginManagerLoginResult = result!
                    if (result?.isCancelled)!{
                        return
                    } else if(fbloginresult.grantedPermissions.contains("email")) {
                        self.getFBUserData()
                        self.fbLoginManager.logOut()
                    } else {
                    }
                } else {
                    KRProgressHUD.showError(withMessage:error!.localizedDescription)
                }
            }
        }
    }
    
    func getFBUserData() {
        let hud = KRProgressHUD .showOn(self)
        hud.show()
        if((AccessToken.current) != nil) {
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: {
                (connection, result, error) -> Void in
                DispatchQueue.main.async {
                    if (error == nil) {
//                        print("self.dictFb --\(result)")
                        let dict = result as? [String:Any]
                        hud.dismiss()
                        self.func_social_login(dict!)
                    } else {
                        hud.showError(withMessage:"\(error!.localizedDescription)")
                        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                            hud.dismiss()
                        }
                    }
                }
            })
        } else {
            hud.dismiss()
        }
    }
    
    func func_social_login(_ dict:[String:Any]) {
        guard let fbid = dict["id"] as? String,
            let fbmail = dict["email"] as? String,
            let full_name = dict["name"] as? String else {
                return
            }
        
        let dict_picture = dict["picture"] as! [String:Any]
        let data = dict_picture["data"] as! [String:Any]
        let url_picture = data["url"] as! String
                        
        let param = [
                "social":fbid,
                "email":fbmail,
                "name":full_name,
                "device_type":"2",
                "device_token":k_FireBaseFCMToken,
                "user_profile":url_picture,
                "user_lat":"\(co_OrdinateCurrent.latitude)",
                "user_lang":"\(co_OrdinateCurrent.longitude)"
        ]
        
        let hud = KRProgressHUD.showOn(self)
        hud.show()
        APIFunc.postAPI("social_login", param) { (json,status,message)  in
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

}



extension Sign_Up_Option_VC:CLLocationManagerDelegate {
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


