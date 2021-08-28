//  New_Topics_ViewController.swift
//  SheDistrict
//  Created by appentus on 1/15/20.
//  Copyright © 2020 appentus. All rights reserved.


import UIKit


class New_Topics_ViewController: UIViewController {
    @IBOutlet weak var tbl_new_topics:UITableView!
    
    let arr_color = ["053FEB","DCB302","EA219B","5B0F72"]
    
    let arr_user_name = ["Lisa Rose","Aryana","Christina","Madeline"]
    let arr_forum_message = ["How do you like SheDistrict so far?","Do you like hot sauce with cheese?","I haven't gotten my period yet, what does this mean?","My daughter won't stop pooping on the floor, what can I do to make her stop?"]
    let arr_forum_type = ["in General Forum","in Food + Drink Forum","in Health + Fitness Forum","in Family + Parenting Forum"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tbl_new_topics.reloadData()
    }
    
    @IBAction func btn_post_a_new_topic(_ sender:UIButton) {
        func_Next_VC_Main_3("Post_a_new_topic_VC")
    }
    
}



extension New_Topics_ViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_user_name.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"cell", for: indexPath) as! Forum_New_Topics_TableCell
        
        let attributedString = NSMutableAttributedString()
        let attr_posted_a_new_titled = func_attributed_string(font_name:"Roboto-Light", text:" posted a new topic titled: ", color:"555555")
        let attr_user_name = func_attributed_string(font_name:"Roboto-Light", text:arr_user_name[indexPath.row], color:"000000")
        let attr_forum_message = func_attributed_string(font_name:"Roboto-LightItalic", text:"\(arr_forum_message[indexPath.row]) ", color:arr_color[indexPath.row])
        let attr_forum_type = func_attributed_string(font_name:"Roboto-Light", text:arr_forum_type[indexPath.row], color:"555555")
        
        attributedString.append(attr_user_name)
        attributedString.append(attr_posted_a_new_titled)
        attributedString.append(attr_forum_message)
        attributedString.append(attr_forum_type)
        
        cell.lbl_topics.attributedText = attributedString
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration:0.25, delay:0.01, animations: {
            cell.alpha = 1
        })
    }
    
}


