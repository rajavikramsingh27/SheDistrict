//  Privacy_ViewController.swift
//  SheDistrict
//  Created by appentus on 1/16/20.
//  Copyright © 2020 appentus. All rights reserved.


import UIKit


class Privacy_ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func btn_messages(_ sender:UIButton) {
        func_Next_VC_Main_3("Privacy_Message_VC")
    }
    
    @IBAction func btn_profile(_ sender:UIButton) {
        func_Next_VC_Main_3("Privacy_Profile_VC")
    }
    
    @IBAction func btn_blocked_users(_ sender:UIButton) {
        func_Next_VC_Main_3("Blocked_Users_VC")
    }
    
    @IBAction func btn_privacy_policy(_ sender:UIButton) {
        func_Next_VC_Main_3("Privacy_Policy_ViewController")
    }
    
  
}
