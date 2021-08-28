//  Settings_ViewController.swift
//  SheDistrict
//  Created by appentus on 1/15/20.
//  Copyright © 2020 appentus. All rights reserved.


import UIKit


class Settings_ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func btn_general(_ sender:UIButton) {
        func_Next_VC_Main_2("General_ViewController")
    }
    
    @IBAction func btn_privacy(_ sender:UIButton) {
        func_Next_VC_Main_3("Privacy_ViewController")
    }
    
    @IBAction func btn_notifications(_ sender:UIButton) {
        func_Next_VC_Main_4("Privacy_Notifications_VC")
    }
    
    @IBAction func btn_purchases(_ sender:UIButton) {
        func_Next_VC_Main_4("Purchases_ViewController")
    }
    
    @IBAction func btn_she_protects(_ sender:UIButton) {
        func_Next_VC_Main_4("Privacy_SheProtects_VC")
    }
    
}
