//  Block_Message_VC.swift
//  SheDistrict
//  Created by appentus on 1/8/20.
//  Copyright © 2020 appentus. All rights reserved.


import UIKit


protocol Delegate_Block {
    func func_cancel_block()
}


class Block_Message_VC: UIViewController {
    
    var delegate:Delegate_Block?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func btn_cancel(_ sender:UIButton) {
        func_removeFromSuperview()
        delegate?.func_cancel_block()
    }
    
}
