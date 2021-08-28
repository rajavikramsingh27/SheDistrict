//
//  Why_Join_Us_VC.swift
//  SheDistrict
//
//  Created by appentus on 1/3/20.
//  Copyright © 2020 appentus. All rights reserved.


import UIKit

class Why_Join_Us_VC: UIViewController {
    @IBOutlet weak var height_container_view:NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func btnJoin_Us(_ sender:UIButton) {
        func_Next_VC("Sign_Up_Option_VC")
    }

}
