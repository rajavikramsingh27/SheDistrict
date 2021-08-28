//  Accepted_ViewController.swift
//  SheDistrict
//  Created by appentus on 1/10/20.
//  Copyright © 2020 appentus. All rights reserved.


protocol Delegate_Event_Invitation {
    func func_cancel()
}


import UIKit


class Event_Invitation_VC: UIViewController {
    @IBOutlet weak var lbl_title:UILabel!
    @IBOutlet weak var lbl_description:UILabel!
    
    var delegate:Delegate_Event_Invitation?
    
    var str_title = ""
    var str_description = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbl_title.text = str_title
        lbl_description.text = str_description
    }
    
    @IBAction func func_cancel(_ sender:UIButton) {
        func_removeFromSuperview()
        delegate?.func_cancel()
    }
    
}
