//
//  Deleted_ViewController.swift
//  SheDistrict
//
//  Created by appentus on 1/7/20.
//  Copyright © 2020 appentus. All rights reserved.


protocol Delegate_Deleted_Message {
    func func_Ok(_ backTime:String)
}


import UIKit


class Deleted_Message_VC: UIViewController {
    @IBOutlet weak var lbl_message_1:UILabel!
    @IBOutlet weak var lbl_message_2:UILabel!
    
    var delegate:Delegate_Deleted_Message?
    var str_message_1 = ""
    var attr_message_2 = NSAttributedString()
    
    var backTime = "1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbl_message_1.text = str_message_1
        lbl_message_2.attributedText = attr_message_2
    }
    
    @IBAction func btn_Ok(_ sender:UIButton) {
        func_removeFromSuperview()
        
        delegate?.func_Ok(backTime)
    }

    
}


