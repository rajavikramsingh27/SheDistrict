//  SheDistrict_TabBar.swift
//  SheDistrict
//  Created by appentus on 1/6/20.
//  Copyright © 2020 appentus. All rights reserved.


import UIKit


var is_active = false
import KRProgressHUD


class TabBar_SheDistrict:UIViewController {
    @IBOutlet var btn_tabbar:[UIButton]!
    @IBOutlet weak var view_dot_selected:UIView!
    
    let arr_dot_selected = ["ffd200","60edac","6071ed","ed60a9","4d245b"]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(func_Deleted_Message), name: NSNotification.Name (rawValue: "search_Deleted_Message"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(func_add_event), name: NSNotification.Name (rawValue:"add_event"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(func_QR_Code), name: NSNotification.Name (rawValue:"show_QR_Code"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(funcYouveBeenInvited), name: NSNotification.Name (rawValue:"YouveBeenInvited"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(funcYouveBeenInvited), name: NSNotification.Name (rawValue:"MessageFriendList"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(btnThreeDot(noti:)), name: NSNotification.Name (rawValue:"ThreeDotAnnouncement"), object: nil)
        
        
        
        for i in 0..<btn_tabbar.count {
            btn_tabbar[i].tag = i+1
        }
        
        btn_tabbar[0].isSelected = true
        view_dot_selected.center.x = btn_tabbar[0].center.x
        view_dot_selected.backgroundColor = hexStringToUIColor(arr_dot_selected[0])
    }
    
    
    @IBAction func btn_tabbar(_ sender:UIButton) {
        for i in 0..<btn_tabbar.count {
            if btn_tabbar[i].tag == sender.tag {
               btn_tabbar[i].isSelected = true
                view_dot_selected.center.x = btn_tabbar[i].center.x
                view_dot_selected.backgroundColor = hexStringToUIColor(arr_dot_selected[i])
            } else {
               btn_tabbar[i].isSelected = false
            }
        }
        
        NotificationCenter.default.post(name: NSNotification.Name (rawValue:"move_by_buttons"), object: sender.tag-1)
        
        UIView.animate(withDuration:0.1, animations: {
            sender.transform = CGAffineTransform(scaleX:0.6, y: 0.6)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1) {
                sender.transform = CGAffineTransform.identity
            }
        })
    }
    
}



// MARK:- Event popups
extension TabBar_SheDistrict:Delegate_Add_Event {
    @objc func func_add_event() {
        let storyboard = UIStoryboard (name: "Main_2", bundle: nil)
        let add_event_VC = storyboard.instantiateViewController(withIdentifier: "Add_Event_ViewController") as! Add_Event_ViewController
        self.addChild(add_event_VC)
        add_event_VC.delegate = self
        
        add_event_VC.view.transform = CGAffineTransform(scaleX:2, y:2)
        
        self.view.addSubview(add_event_VC.view)
        UIView.animate(withDuration:0.2, delay: 0, usingSpringWithDamping:0.7, initialSpringVelocity: 0, options: [],  animations: {
            add_event_VC.view.transform = .identity
        })
    }
    
    func func_rules_tips() {
        let storyboard = UIStoryboard (name: "PopUp", bundle: nil)
        let add_event_VC = storyboard.instantiateViewController(withIdentifier: "Rules_Tips_Safe_Meeting_VC") as! Rules_Tips_Safe_Meeting_VC
        self.addChild(add_event_VC)
        
        add_event_VC.view.transform = CGAffineTransform(scaleX:2, y:2)
        
        self.view.addSubview(add_event_VC.view)
        UIView.animate(withDuration:0.2, delay: 0, usingSpringWithDamping:0.7, initialSpringVelocity: 0, options: [],  animations: {
            add_event_VC.view.transform = .identity
        })
    }
    
}



extension TabBar_SheDistrict {
    @objc func func_QR_Code() {
        let storyboard = UIStoryboard (name: "Main_3", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "QR_Code_ViewController") as! QR_Code_ViewController
        self.addChild(vc)
        
        vc.view.transform = CGAffineTransform(scaleX:2, y:2)
        
        self.view.addSubview(vc.view)
        UIView.animate(withDuration:0.2, delay: 0, usingSpringWithDamping:0.7, initialSpringVelocity: 0, options: [],  animations: {
            vc.view.transform = .identity
        })
    }
    
    @objc func func_Deleted_Message() {
        funcDeletedMessage("Swipe right on a category to view all", "users with the ", "most things in common.")
    }
    
}


// MARK:- Delegate_Deleted_Message
extension UIViewController :Delegate_Deleted_Message {
    func funcDeletedMessage(_ str_message_1:String,_ attr_message_2:String,_ attr_message_3:String) {
        let storyboard = UIStoryboard (name: "PopUp", bundle: nil)
        let deleted_Message_VC = storyboard.instantiateViewController(withIdentifier: "Deleted_Message_VC") as! Deleted_Message_VC
        deleted_Message_VC.delegate = self
        deleted_Message_VC.str_message_1 = str_message_1
        deleted_Message_VC.attr_message_2 = func_attributed_text(UIColor.darkGray,UIColor .black, UIFont(name:"Roboto-Light", size: 16.0)!, UIFont (name:"Roboto-Regular", size: 16.0)!, attr_message_2, attr_message_3)
        
        self.addChild(deleted_Message_VC)
        
        deleted_Message_VC.view.transform = CGAffineTransform(scaleX:2, y:2)
        
        self.view.addSubview(deleted_Message_VC.view)
        UIView.animate(withDuration:0.2, delay: 0, usingSpringWithDamping:0.7, initialSpringVelocity: 0, options: [],  animations: {
            deleted_Message_VC.view.transform = .identity
        })
    }
        
    func func_Ok(_ backTime:String) {
        if backTime == "1" {
            btn_back("")
        } else {
            navigationController?.popToViewController((navigationController?.viewControllers[1])!, animated: true)
        }
    }
        
}



// MARK:- Event methods
extension TabBar_SheDistrict:Delegate_You_ve_been_Invited {
    @objc func funcYouveBeenInvited() {
        let storyboard = UIStoryboard (name: "PopUp", bundle: nil)
        let add_event_VC = storyboard.instantiateViewController(withIdentifier: "You_ve_been_InvitedVC") as! You_ve_been_InvitedVC
        self.addChild(add_event_VC)
        add_event_VC.delegate = self
        add_event_VC.view.transform = CGAffineTransform(scaleX:2, y:2)
        
        self.view.addSubview(add_event_VC.view)
        UIView.animate(withDuration:0.2, delay: 0, usingSpringWithDamping:0.7, initialSpringVelocity: 0, options: [],  animations: {
            add_event_VC.view.transform = .identity
        })
        
    }
    
    func func_accept(_ userName:String) {
        func_show_event_invitaion("Awesome!","You accepted an invitation from (\(userName)). Check under your “events” tab to keep track of your upcoming and pending events!")
    }
    
    func func_deny(_ userName:String) {
        func_show_event_invitaion("Well that’s okay! No pressure.","However, if you change your mind, you still can create your own event and invite (\(userName)).")
    }
    
    func func_i_will_think_about_it() {
        
    }
        
    func func_send_invitation(_ message: String) {
        KRProgressHUD.showSuccess(withMessage:message)
    }
    
    func func_rules_nevermind() {
        func_show_event_invitaion("You,ve been invited!", "If you change your mind, your invitation is saved at pending invitations.")
    }
    
    func func_show_event_invitaion(_ title:String, _ description:String) {
        let storyboard = UIStoryboard (name: "PopUp", bundle: nil)
        let add_event_VC = storyboard.instantiateViewController(withIdentifier: "Event_Invitation_VC") as! Event_Invitation_VC
        add_event_VC.str_title = title
        add_event_VC.str_description = description
        self.addChild(add_event_VC)
        
        add_event_VC.view.transform = CGAffineTransform(scaleX:2, y:2)
        self.view.addSubview(add_event_VC.view)
        UIView.animate(withDuration:0.2, delay: 0, usingSpringWithDamping:0.7, initialSpringVelocity: 0, options: [],  animations: {
            add_event_VC.view.transform = .identity
        })
    }
    
}



extension TabBar_SheDistrict:Delegate_Report_Resion {
    func func_select_resion() {
        NotificationCenter.default.post(name: NSNotification.Name (rawValue: "funcRefresh"), object: nil)
    }
    
    @objc func btnThreeDot(noti:Notification) {
        let userDetails = noti.object as! [User]
        if userDetails.count > 0 {
            if signUp?.userID == userDetails[0].userID {
                funcAlertController("Alert! \nIt's your ad")
            } else {
               let storyboard = UIStoryboard (name: "PopUp", bundle: nil)
                let repostReason = storyboard.instantiateViewController(withIdentifier: "Report_Resion_ViewController") as! Report_Resion_ViewController
                repostReason.friend_id = userDetails[0].userID
                repostReason.arr_resion = ["This post is offensive",
                                            "This post is inappropriate",
                                            "This post violates the rules"]
                repostReason.delegate = self
                self.addChild(repostReason)
                
                repostReason.view.transform = CGAffineTransform(scaleX:2, y:2)
                
                self.view.addSubview(repostReason.view)
                UIView.animate(withDuration:0.2, delay: 0, usingSpringWithDamping:0.7, initialSpringVelocity: 0, options: [],  animations: {
                    repostReason.view.transform = .identity
                })
            }
        } else {
            funcAlertController("This post's user details not found")
        }
    }
    
    
    
    
}
