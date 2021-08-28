//
//  UnBlock_VC.swift
//  SheDistrict
//
//  Created by appentus on 1/8/20.
//  Copyright © 2020 appentus. All rights reserved.
//


protocol Delegate_UnBlock {
    func func_Yes()
    func func_No()
    func func_how_it_works()
}


import UIKit


class UnBlock_VC: UIViewController {
    var delegate:Delegate_UnBlock?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func btn_Yes(_ sender:UIButton) {
        func_removeFromSuperview()
        delegate?.func_Yes()
    }
    
    @IBAction func btn_No(_ sender:UIButton) {
        func_removeFromSuperview()
        delegate?.func_No()
    }
    
    @IBAction func btn_how_it_works(_ sender:UIButton) {
        func_removeFromSuperview()
        delegate?.func_how_it_works()
    }
    
    
    
}


