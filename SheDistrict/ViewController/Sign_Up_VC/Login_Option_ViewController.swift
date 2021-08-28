//  Login_Option_ViewController.swift
//  SheDistrict
//  Created by appentus on 1/2/20.
//  Copyright © 2020 appentus. All rights reserved.


import UIKit

//client=safari%channel=bm
class Login_Option_ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func btn_why_join_us(_ sender:Any) {
        func_Next_VC("Why_Join_Us_VC")
    }
    
    @IBAction func btn_signUp(_ sender:Any) {
        func_Next_VC("Sign_Up_Option_VC")
    }
    
    @IBAction func btn_login(_ sender:Any) {
        func_Next_VC_Main_1("Log_In_ViewController")
    }
    
}
