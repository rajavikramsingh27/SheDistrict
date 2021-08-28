//
//  Forum_ViewController.swift
//  SheDistrict
//
//  Created by appentus on 1/15/20.
//  Copyright © 2020 appentus. All rights reserved.
//

import UIKit

class Forum_ViewController: UIViewController {
    @IBOutlet var btn_selected:[UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0..<btn_selected.count {
            btn_selected[i].tag = i+1
        }
        
        for i in 0..<btn_selected.count {
            if btn_selected[i].tag == 1 {
                btn_selected[i].setTitleColor(UIColor .black, for:.normal)
            } else {
                btn_selected[i].setTitleColor(UIColor .darkGray, for:.normal)
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(func_set_selected(noti:)),name:NSNotification.Name(rawValue:"selected_forum"), object: nil)
    }
    
    @IBAction func btn_selected(_ sender:UIButton) {
        for i in 0..<btn_selected.count {
            if btn_selected[i].tag == sender.tag {
                btn_selected[sender.tag-1].setTitleColor(UIColor .black, for:.normal)
            } else {
                btn_selected[i].setTitleColor(UIColor .darkGray, for:.normal)
            }
        }
        
        NotificationCenter.default.post(name: NSNotification.Name (rawValue:"move_by_buttons_forum"), object: sender.tag-1)
    }
    
    @objc func func_set_selected(noti:Notification)  {
        let selected_tag = noti.object as! Int
        
        for i in 0..<btn_selected.count {
            if i == selected_tag {
                btn_selected[selected_tag].setTitleColor(UIColor .black, for:.normal)
            } else {
                btn_selected[i].setTitleColor(UIColor .darkGray, for:.normal)
            }
        }
        
    }
    
}
