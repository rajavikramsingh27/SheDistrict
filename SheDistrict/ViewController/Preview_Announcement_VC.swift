//  Preview_Announcement_VC.swift
//  SheDistrict
//  Created by appentus on 1/7/20.
//  Copyright © 2020 appentus. All rights reserved.


import UIKit
import KRProgressHUD


class Preview_Announcement_VC: UIViewController {
    @IBOutlet weak var img_user_profile:UIImageView!
    @IBOutlet weak var lbl_user_name:UILabel!
    @IBOutlet weak var lbl_time:UILabel!
    
    @IBOutlet weak var lbl_title:UILabel!
//    @IBOutlet weak var lbl_category:UILabel!
    @IBOutlet weak var img_annoucement:UIImageView!
    @IBOutlet weak var lbl_description:UILabel!
    
    var arr_annoucement = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        func_set_UI()
    }
    
    func func_set_UI() {
        img_user_profile.sd_setImage(with: URL(string:signUp!.userProfile), placeholderImage:k_default_user)
        lbl_user_name.text = signUp?.userName
        
        let date_formatter = DateFormatter()
        date_formatter.dateFormat = "hh:mm a"
        lbl_time.text = "Today, \(date_formatter.string(from:Date()))"
        
        lbl_title.text = "\(arr_annoucement[0])"
//        lbl_category.text = postcategory[Int("\(arr_annoucement[1])")!].categoryName
        img_annoucement.image = arr_annoucement[2] as? UIImage
        lbl_description.text = "\(arr_annoucement[3])"
    }
    
    @IBAction func btn_submit(_ sender:UIButton) {
        let param = [
            "user_id":signUp!.userID,
            "category_id":postcategory[Int("\(arr_annoucement[1])")!].categoryID,
            "announcement_title":lbl_title.text!,
            "announcement_desc":lbl_description.text!
            ] as [String:String]
        print(param)
        
        let hud = KRProgressHUD.showOn(self)
        hud.show()
        APIFunc.postAPI_Image("add_announcement", img_annoucement.image!.jpegData(compressionQuality: 0.2), param, "image") { (json, status, message) in
            DispatchQueue.main.async {
                hud.dismiss()
                if status == success_resp {
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                        self.btn_Deleted_Message()
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                        hud.showError(withMessage: message)
                    }
                }
            }
        }
    }
        
}



extension Preview_Announcement_VC {
    func btn_Deleted_Message() {
        let storyboard = UIStoryboard (name: "PopUp", bundle: nil)
        let deleted_Message_VC = storyboard.instantiateViewController(withIdentifier: "Deleted_Message_VC") as! Deleted_Message_VC
        deleted_Message_VC.str_message_1 = "Your announcement"
        deleted_Message_VC.attr_message_2 = func_attributed_text(UIColor.darkGray,UIColor .black, UIFont(name:"Roboto-Light", size: 16.0)!, UIFont (name:"Roboto-Regular", size: 16.0)!,"has been ","posted!")
        deleted_Message_VC.backTime = "2"
        deleted_Message_VC.delegate = self
        
        self.addChild(deleted_Message_VC)
        
        deleted_Message_VC.view.transform = CGAffineTransform(scaleX:2, y:2)
        
        self.view.addSubview(deleted_Message_VC.view)
        UIView.animate(withDuration:0.2, delay: 0, usingSpringWithDamping:0.7, initialSpringVelocity: 0, options: [],  animations: {
            deleted_Message_VC.view.transform = .identity
        })
        
    }
}
