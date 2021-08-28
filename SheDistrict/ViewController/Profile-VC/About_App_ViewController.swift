//
//  About_App_ViewController.swift
//  SheDistrict
//  Created by appentus on 1/15/20.
//  Copyright © 2020 appentus. All rights reserved.



import UIKit
import KRProgressHUD



class About_App_ViewController: UIViewController {
    @IBOutlet weak var lblText:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        funcGeneral()
    }
    
}



extension About_App_ViewController {
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
                                self.lblText.text = generalInfo[0].appAbout
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
            lblText.text = generalInfo[0].appAbout
        }
    }
    
}

