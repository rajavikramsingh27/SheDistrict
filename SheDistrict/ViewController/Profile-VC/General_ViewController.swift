//
//  General_ViewController.swift
//  SheDistrict
//
//  Created by appentus on 1/15/20.
//  Copyright © 2020 appentus. All rights reserved.
//

import UIKit

class General_ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func btn_about(_ sender:UIButton) {
        func_Next_VC_Main_2("About_App_ViewController")
    }
    
    @IBAction func btn_she_update(_ sender:UIButton) {
        func_Next_VC_Main_2("She_Update_ViewController")
    }
    
    @IBAction func btn_she_rules(_ sender:UIButton) {
        func_Next_VC_Main_2("She_Rules_Profile_VC")
    }
    
    @IBAction func btn_message_from_CEO(_ sender:UIButton) {
        func_Next_VC_Main_2("Message_From_CEO_VC")
    }

}
