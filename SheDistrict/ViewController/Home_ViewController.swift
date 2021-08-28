//  Home_ViewController.swift
//  SheDistrict
//  Created by appentus on 1/6/20.
//  Copyright © 2020 appentus. All rights reserved.


import UIKit


class Home_ViewController:UIViewController {
    @IBOutlet weak var lblSelectedCategory:UILabel!
    @IBOutlet var btnCategory:[UIButton]!
    @IBOutlet var btn_selected_announcements:[UIButton]!
    @IBOutlet weak var view_dot_selected:UIView!
    @IBOutlet weak var btn_show_all:UIButton!
    @IBOutlet weak var height_show_details_shouts:NSLayoutConstraint!
    @IBOutlet weak var view_show_details_shouts:UIView!
    @IBOutlet weak var view_light_shadow:UIView!
    
    let arr_dot_selected = ["ffd200","E1E1E1"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        height_show_details_shouts.constant = 0
        view_show_details_shouts.isHidden = true
        view_light_shadow.isHidden = true
        
        for i in 0..<btn_selected_announcements.count {
            btn_selected_announcements[i].tag = i+1
        }
        
        for i in 0..<btnCategory.count {
            btnCategory[i].tag = i
            btnCategory[i].addTarget(self, action:#selector(btnCategory(_:)), for:.touchUpInside)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(func_set_selected(noti:)),name:NSNotification.Name(rawValue:"selected_announcements"), object: nil)
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
    
    @IBAction func btnCategory(_ sender:UIButton) {
        for i in 0..<btnCategory.count {
            if i == sender.tag {
                btnCategory[i].setTitleColor(UIColor.black, for: .normal)
                lblSelectedCategory.text = btnCategory[i].currentTitle!
                NotificationCenter.default.post(name: NSNotification.Name (rawValue:"funcRefresh"), object:nil)
            } else {
                btnCategory[i].setTitleColor(UIColor.lightGray, for: .normal)
            }
        }
        btn_show_all(sender)
    }
    
    @IBAction func btn_add_new_post(_ sender:Any) {
        func_Next_VC_Main_1("New_Post_VC")
    }
    
    @IBAction func btn_show_all(_ sender:UIButton) {
        btn_show_all.isSelected = !btn_show_all.isSelected
        
        if btn_show_all.isSelected {
            height_show_details_shouts.constant = 130
            view_show_details_shouts.isHidden = false
            view_light_shadow.isHidden = false
            
            UIView.animate(withDuration:1) {
                self.view_light_shadow.alpha = 1.0
            }
        } else {
            height_show_details_shouts.constant = 0
            UIView.animate(withDuration: 1, animations: {
                self.view_light_shadow.alpha = 0.0
            }) { (is_alpha) in
                if !self.btn_show_all.isSelected {
                    self.view_light_shadow.isHidden = true
                }
            }
        }
        
        UIView.animate(withDuration:0.3, animations: {
            self.view.layoutIfNeeded()
        }) { (is_alpha) in
            if !self.btn_show_all.isSelected {
                self.view_show_details_shouts.isHidden = true
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
        
        NotificationCenter.default.post(name: NSNotification.Name (rawValue:"move_by_buttons_home"), object: sender.tag-1)
    }
 
    
}

