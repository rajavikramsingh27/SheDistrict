//
//  Post_a_new_topic_VC.swift
//  SheDistrict
//
//  Created by appentus on 1/15/20.
//  Copyright © 2020 appentus. All rights reserved.
//

import UIKit

class Post_a_new_topic_VC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    

}


extension Post_a_new_topic_VC:UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Enter a description for your topic" {
            textView.textColor = UIColor .black
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.textColor = UIColor .lightGray
            textView.text = "Enter a description for your topic"
        }
    }
}
