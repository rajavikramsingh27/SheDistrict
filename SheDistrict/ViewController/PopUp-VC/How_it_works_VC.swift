//  How_it_works_VC.swift
//  SheDistrict
//  Created by appentus on 1/8/20.
//  Copyright © 2020 appentus. All rights reserved.


protocol Delegate_How_it_works {
    func func_cancel_How_it_works()
    func func_agree_How_it_works()
}


import UIKit
import KRProgressHUD

class How_it_works_VC: UIViewController {
    @IBOutlet weak var txt_how_it_works:UITextView!
    
    var delegate:Delegate_How_it_works?
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
//        let attrs1 = [NSAttributedString.Key.font:UIFont (name:"Roboto-Light", size:16.0), NSAttributedString.Key.foregroundColor:hexStringToUIColor("ED5FA9")]
//        let attributedString1 = NSMutableAttributedString(string:"How this works\n\n", attributes:attrs1)
//  
//        attributedString1.append(func_attributed_string(font_name: "Roboto-Light", text:"Both of you are receiving this message at the same time.\n", color:"a9a9a9"))
//        attributedString1.append(func_attributed_string(font_name: "Roboto-Bold", text:"If both of you say yes, ", color:"a9a9a9"))
//        attributedString1.append(func_attributed_string(font_name: "Roboto-Light", text:"you will be taken to a page to schedule a girl date.\n", color:"a9a9a9"))
//        attributedString1.append(func_attributed_string(font_name: "Roboto-Bold", text:"If both of you say no, ", color:"a9a9a9"))
//        attributedString1.append(func_attributed_string(font_name: "Roboto-Light", text:"your messages will disappear, but you will still see this person in the browse section if you would like to connect with them again.\n", color:"a9a9a9"))
//        attributedString1.append(func_attributed_string(font_name: "Roboto-Bold", text:"If you say yes and she says no, ", color:"a9a9a9"))
//        attributedString1.append(func_attributed_string(font_name: "Roboto-Light", text:"your messages will be paused and you won’t be able to contact each other until you are ready to meet.\n\n", color:"a9a9a9"))
//        attributedString1.append(func_attributed_string(font_name: "Roboto-Light", text:"Why?\n\n", color:"ED5FA9"))
//        attributedString1.append(func_attributed_string(font_name: "Roboto-Light", text:"This is how we encourage meeting in person. We understand that people get busy, but it is important to be able to communicate offline as well. We think that two weeks is more than enough time to make yourselves comfortable with meeting offline. \nDisagree? Tell us why ", color:"a9a9a9"))
//        attributedString1.append(func_attributed_string(font_name: "Roboto-Light", text:"here.", color:"ED5FA9"))
//
//        txt_how_it_works.attributedText = attributedString1
//        txt_how_it_works.textAlignment = .center
        
        funcGetMeetContent()
    }
    
    @IBAction func btn_cancel(_ sender:UIButton) {
        func_removeFromSuperview()
        delegate?.func_cancel_How_it_works()
    }
    
    @IBAction func btn_agreed(_ sender:UIButton) {
        func_removeFromSuperview()
        delegate?.func_agree_How_it_works()
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
                            self.txt_how_it_works.attributedText = getMeetContent[0].howItsWork.htmlToAttributedString
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
            self.txt_how_it_works.attributedText = getMeetContent[0].howItsWork.htmlToAttributedString
        }
       
    }
    
    
}


