//  Home_ViewController.swift
//  SheDistrict
//  Created by appentus on 1/6/20.
//  Copyright © 2020 appentus. All rights reserved.


import UIKit


class Event_ViewController: UIViewController {
    @IBOutlet var btn_selected_announcements:[UIButton]!
    @IBOutlet weak var view_dot_selected:UIView!
    let arr_dot_selected = ["5B6DEC","E1E1E1"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0..<btn_selected_announcements.count {
            btn_selected_announcements[i].tag = i+1
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(func_set_selected(noti:)),name:NSNotification.Name(rawValue:"selected_events"), object: nil)
    }
    
    @objc func func_set_selected(noti:Notification)  {
        let selected_tag = noti.object as! Int
        
        for i in 0..<btn_selected_announcements.count {
            if i == selected_tag {
                view_dot_selected.center.x = btn_selected_announcements[i].center.x
                btn_selected_announcements[selected_tag].setTitleColor(hexStringToUIColor(arr_dot_selected[0]), for:.normal)
            } else {
                btn_selected_announcements[i].setTitleColor(hexStringToUIColor(arr_dot_selected[1]), for:.normal)
            }
        }
        
    }
    
    @IBAction func btn_selected_announcements(_ sender:UIButton) {
        for i in 0..<btn_selected_announcements.count {
            if btn_selected_announcements[i].tag == sender.tag {
                view_dot_selected.center.x = btn_selected_announcements[i].center.x
                btn_selected_announcements[sender.tag-1].setTitleColor(hexStringToUIColor(arr_dot_selected[0]), for:.normal)
            } else {
                btn_selected_announcements[i].setTitleColor(hexStringToUIColor(arr_dot_selected[1]), for:.normal)
            }
        }
        
        NotificationCenter.default.post(name: NSNotification.Name (rawValue:"move_by_buttons_events"), object: sender.tag-1)
    }
    
    @IBAction func btn_add_event(_ sender:Any) {
        NotificationCenter.default.post(name: NSNotification.Name (rawValue:"add_event"), object:nil)
    }
    
}

