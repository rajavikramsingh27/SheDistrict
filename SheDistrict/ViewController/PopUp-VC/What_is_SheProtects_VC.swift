//
//  What_is_SheProtects_VC.swift
//  SheDistrict
//
//  Created by appentus on 1/16/20.
//  Copyright © 2020 appentus. All rights reserved.
//



protocol Delegate_What_is_SheProtects {
    func func_cancel_What_is_SheProtects()
}

import UIKit


class What_is_SheProtects_VC: UIViewController {
    
    var delegate:Delegate_What_is_SheProtects?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func func_cancel(_ sender:UIButton) {
        func_removeFromSuperview()
    }
    
}
