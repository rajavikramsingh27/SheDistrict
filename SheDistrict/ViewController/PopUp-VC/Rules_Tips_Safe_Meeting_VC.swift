//  Rules_Tips_Safe_Meeting_VC.swift
//  SheDistrict
//  Created by appentus on 1/10/20.
//  Copyright © 2020 appentus. All rights reserved.


protocol Delegate_RulesTipsSafeMeeting {
    func func_Got_it()
}


import UIKit
import KRProgressHUD


class Rules_Tips_Safe_Meeting_VC: UIViewController {
    @IBOutlet weak var txt_rules_tips:UITextView!

    let str_1 = "Before meeting, make sure you have a good sense of who the person you’re meeting is \n*Confirm that their pictures are real\n*Exchange numbers and have a conversation/video chat before meeting.\n\n"
    let str_2 = "Do not share any sensitive information (i.e, address)\n\n"
    let str_3 = "Let close friends and family know where you are going and who you are expecting to meet \n*Activate SheProtects to be able to access your friends or the police discreetly\n\n"
    let str_4 = "Do not meet in areas your unfamiliar with\n\n"
    let str_5 = "Call the venue you’re meeting at ahead of time to let them know you are visiting to meet someone that you’ve met online\n\n"
    let str_6 = "Most importantly, have fun!\n\n"
    
    
    var delegate:Delegate_RulesTipsSafeMeeting?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        funcGetMeetContent()
    }
    
    @IBAction func btn_Got_it(_ sender:UIButton) {
        func_removeFromSuperview()
        delegate?.func_Got_it()
    }
    
    
    
    func funcGetMeetContent() {
        if getMeetContent.count == 0 {
           let hud = KRProgressHUD.showOn(self)
           hud.show()
           APIFunc.getAPI("get_meet_content", [:]) { (json,status,message)  in
               DispatchQueue.main.async {
                   hud.dismiss()
                   
                   let status = return_status(json.dictionaryObject!)
                   switch status {
                   case .success:
                       let decoder = JSONDecoder()
                       if let jsonData = json[result_resp].description.data(using: .utf8) {
                           do {
                                getMeetContent = try decoder.decode([GetMeetContent].self, from: jsonData)
                                self.txt_rules_tips.attributedText = getMeetContent[0].ruleTips.htmlToAttributedString
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
            self.txt_rules_tips.attributedText = getMeetContent[0].ruleTips.htmlToAttributedString
        }
       
    }
    
}

