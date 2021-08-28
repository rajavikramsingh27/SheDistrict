//  Report_ViewController.swift
//  SheDistrict
//  Created by appentus on 1/8/20.
//  Copyright © 2020 appentus. All rights reserved.


protocol Delegate_Report {
    func func_Report()
    func func_Block()
}


import UIKit


class Report_ViewController: UIViewController {
    @IBOutlet weak var lbl_message_1:UILabel!
    @IBOutlet weak var lbl_message_2:UILabel!
    
    var delegate:Delegate_Report?
    var str_message_1 = ""
    var str_message_2 = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        lbl_message_1.text = str_message_1
//        lbl_message_2.text = str_message_2
    }
    
    @IBAction func btn_report(_ sender:UIButton) {
        func_removeFromSuperview()
        delegate?.func_Report()
    }
    
    @IBAction func btn_block(_ sender:UIButton) {
        func_removeFromSuperview()
        delegate?.func_Block()
    }
    
    @IBAction func btn_cancel(_ sender:UIButton) {
        func_removeFromSuperview()
    }
    

    
}
