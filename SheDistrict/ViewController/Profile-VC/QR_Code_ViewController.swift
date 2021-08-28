//  QR_Code_ViewController.swift
//  SheDistrict
//  Created by appentus on 1/15/20.
//  Copyright © 2020 appentus. All rights reserved.


import UIKit


protocol Delegate_QR_Code {
    func func_Cancel_QR_Code()
}


class QR_Code_ViewController: UIViewController {
    
    var delegate:Delegate_QR_Code?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func btn_close(_ sender:UIButton) {
        func_removeFromSuperview()
        delegate?.func_Cancel_QR_Code()
    }
    
    
    
}
