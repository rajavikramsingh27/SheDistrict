//  Privacy_SheProtects_VC.swift
//  SheDistrict
//  Created by appentus on 1/16/20.
//  Copyright © 2020 appentus. All rights reserved.


import UIKit


class Privacy_SheProtects_VC: UIViewController {
    @IBOutlet weak var view_call_friends:UIView!
    @IBOutlet weak var view_message_friends:UIView!
    
    @IBOutlet weak var tbl_call_friends:UITableView!
    @IBOutlet weak var tbl_message_friends:UITableView!
    
    @IBOutlet weak var lbl_sheprotect_active:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        func_add_call_friends()
        func_add_message_friends()
    }
    
    func func_add_call_friends() {
        view_call_friends.frame = self.view.frame
        self.view.addSubview(view_call_friends)
        
        view_call_friends.isHidden = true
    }
    
    func func_add_message_friends() {
        view_message_friends.frame = self.view.frame
        self.view.addSubview(view_message_friends)
        
        view_message_friends.isHidden = true
    }
    
    @IBAction func btn_what_is_sheprotects(_ sender:UIButton) {
        let storyboard = UIStoryboard (name: "PopUp", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "What_is_SheProtects_VC") as! What_is_SheProtects_VC
        self.addChild(vc)
        vc.view.transform = CGAffineTransform(scaleX:2, y:2)
        
        self.view.addSubview(vc.view)
        UIView.animate(withDuration:0.2, delay: 0, usingSpringWithDamping:0.7, initialSpringVelocity: 0, options: [],  animations: {
            vc.view.transform = .identity
        })
    }
    
    @IBAction func btn_call(_ sender:UIButton) {
        view_call_friends.transform = CGAffineTransform(scaleX:2, y:2)
        view_call_friends.isHidden = false
        
        UIView.animate(withDuration:0.2, delay: 0, usingSpringWithDamping:0.7, initialSpringVelocity: 0, options: [],  animations: {
            self.view_call_friends.transform = .identity
        })
    }
    
    @IBAction func btn_cancel(_ sender:UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping:0.5, initialSpringVelocity: 0, options: [], animations: {
            self.view_call_friends.transform = CGAffineTransform(scaleX:0.02, y: 0.02)
        }) { (success) in
            self.view_call_friends.isHidden = true
        }
    }
    
    @IBAction func btn_text(_ sender:UIButton) {
        view_message_friends.transform = CGAffineTransform(scaleX:2, y:2)
        view_message_friends.isHidden = false
        
        UIView.animate(withDuration:0.2, delay: 0, usingSpringWithDamping:0.7, initialSpringVelocity: 0, options: [],  animations: {
            self.view_message_friends.transform = .identity
        })
    }
    
    @IBAction func btn_cancel_message(_ sender:UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping:0.5, initialSpringVelocity: 0, options: [], animations: {
            self.view_message_friends.transform = CGAffineTransform(scaleX:0.02, y: 0.02)
        }) { (success) in
            self.view_message_friends.isHidden = true
        }
    }
    
    @IBAction func btn_friends_list(_ sender:UIButton) {
        func_Next_VC_Main_4("Friends_List_ViewController")
    }
    
    @IBAction func switch_sheprotect_active(_ sender:UISwitch) {
        lbl_sheprotect_active.text = sender.isOn ? "SheProtects is currently active" : "SheProtects is currently inactive"
    }
    
}



extension Privacy_SheProtects_VC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tbl_call_friends {
            return 70
        } else {
            return 70
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tbl_call_friends {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for:indexPath)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for:indexPath)
            
            return cell
        }
    }
    
}
