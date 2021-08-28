//
//  Paused_ViewController.swift
//  SheDistrict
//
//  Created by appentus on 1/8/20.
//  Copyright © 2020 appentus. All rights reserved.



protocol Delegate_Paused_Conversation {
    func func_ready_to_meet()
    func func_dont_want_to_meet()
    func func_why_isOurConversationPaused()
}


import UIKit


class Paused_Conversation_VC: UIViewController {
    var delegate:Delegate_Paused_Conversation?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func btn_ready_to_meet(_ sender:UIButton) {
        func_removeFromSuperview()
        delegate?.func_ready_to_meet()
    }
    
    @IBAction func btn_dont_want_to_meet(_ sender:UIButton) {
        func_removeFromSuperview()
        delegate?.func_dont_want_to_meet()
    }
    
    @IBAction func btn_why_isOurConversationPaused(_ sender:UIButton) {
        func_removeFromSuperview()
        delegate?.func_why_isOurConversationPaused()
    }
    
    
    
}


