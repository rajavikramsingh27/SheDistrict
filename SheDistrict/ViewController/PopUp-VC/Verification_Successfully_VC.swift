//
//  Verification_Successfully_VC.swift
//  SheDistrict
//
//  Created by Appentus Technologies on 2/6/20.
//  Copyright © 2020 appentus. All rights reserved.
//

import UIKit

protocol DelegateVerificationSuccessfully {
    func func_DelegateVerificationCancel()
}

class Verification_Successfully_VC: UIViewController {
    var delegate:DelegateVerificationSuccessfully?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func btn_cancel(_ sender:UIButton) {
        func_removeFromSuperview()
        delegate?.func_DelegateVerificationCancel()
    }

}
