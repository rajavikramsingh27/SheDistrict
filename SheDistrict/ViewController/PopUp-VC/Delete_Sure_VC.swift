//  Delete_Sure_VC.swift
//  SheDistrict
//  Created by appentus on 1/7/20.
//  Copyright © 2020 appentus. All rights reserved.


protocol Delegate_Delete_Sure {
    func func_Yes()
    func func_No()
}

import UIKit

class Delete_Sure_VC: UIViewController {
    @IBOutlet weak var lbl_up:UILabel!
    @IBOutlet weak var lbl_down:UILabel!
    
    var delegate:Delegate_Delete_Sure?
    
    var str_up = ""
    var str_down = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !str_up.isEmpty {
            lbl_up.text = str_up
        }
        
        if !str_down.isEmpty {
            lbl_down.text = str_down
            
            if str_down.lowercased().contains("Log".lowercased()) {
                lbl_up.text = ""
            }
        }
        
    }
    
    @IBAction func btn_Yes(_ sender:UIButton) {
        func_removeFromSuperview()
        
        delegate?.func_Yes()
    }
    
    @IBAction func btn_No(_ sender:UIButton) {
        func_removeFromSuperview()
        
        delegate?.func_No()
    }
    
    
}
