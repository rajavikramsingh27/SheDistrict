//  Privacy_Policy_ViewController.swift
//  SheDistrict
//  Created by appentus on 1/16/20.
//  Copyright © 2020 appentus. All rights reserved.


import UIKit
import KRProgressHUD


class Privacy_Policy_ViewController: UIViewController {
    @IBOutlet weak var txt_privacy:UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        if getPrivacyTerms == nil {
           let hud = KRProgressHUD.showOn(self)
           hud.show()
           APIFunc.getAPI("get_privacy_terms", [:]) { (json,status,message)  in
               DispatchQueue.main.async {
                   hud.dismiss()
                   
                   let status = return_status(json.dictionaryObject!)
                   switch status {
                   case .success:
                       let decoder = JSONDecoder()
                       if let jsonData = json[result_resp].description.data(using: .utf8) {
                           do {
                                getPrivacyTerms = try decoder.decode(GetPrivacyTerms.self, from: jsonData)
                                self.txt_privacy.attributedText = getPrivacyTerms?.privacyPolicy.htmlToAttributedString
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
            self.txt_privacy.attributedText = getPrivacyTerms?.privacyPolicy.htmlToAttributedString
        }
       
    }
    
}
