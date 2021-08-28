//  Message_From_CEO_VC.swift
//  SheDistrict
//  Created by appentus on 1/15/20.
//  Copyright © 2020 appentus. All rights reserved.

import UIKit
import KRProgressHUD


class Message_From_CEO_VC: UIViewController {
    @IBOutlet weak var lblText:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        funcGeneral()
    }
    
}



extension Message_From_CEO_VC {
    func funcGeneral() {
        if generalInfo.count == 0 {
            let hud = KRProgressHUD.showOn(self)
            hud.show()
            
            APIFunc.getAPI("app_content",[:]) { (json,status,message)  in
                DispatchQueue.main.async {
                    hud.dismiss()
                    
                    let status = return_status(json.dictionaryObject!)
                    switch status {
                    case .success:
                        let decoder = JSONDecoder()
                        if let jsonData = json[result_resp].description.data(using: .utf8) {
                            do {
                                generalInfo = try decoder.decode([GeneralInfo].self, from: jsonData)
                                self.lblText.text = generalInfo[0].ceoMsg
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
        } else {
            lblText.text = generalInfo[0].ceoMsg
        }
    }
    
}

extension Message_From_CEO_VC {
    @IBAction func btn_instagram(_ sender:UIButton) {
        let url_insta = URL(string:generalInfo[0].ceoSocialLink)
        
        if UIApplication.shared.canOpenURL(url_insta!) {
            UIApplication.shared.open(url_insta!, options:[:], completionHandler: nil)
        } else {
            UIApplication.shared.open(url_insta!, options:[:], completionHandler: nil)
        }
        
    }
    
    @IBAction func btn_twitter(_ sender:UIButton) {
        let url_twitter = URL(string:generalInfo[0].ceoSocialLink)
        
        if UIApplication.shared.canOpenURL(url_twitter!) {
            UIApplication.shared.open(url_twitter!, options:[:], completionHandler: nil)
        } else {
            UIApplication.shared.open(url_twitter!, options:[:], completionHandler: nil)
        }
        
    }
    
}
