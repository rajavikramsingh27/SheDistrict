//  Announcement_VC.swift
//  SheDistrict
//  Created by appentus on 1/7/20.
//  Copyright © 2020 appentus. All rights reserved.


import UIKit
import KRProgressHUD


var get_details:GetAnnouncement?


class Announcement_Details_VC: UIViewController,Delegate_Delete_Sure {
    @IBOutlet weak var img_user_profile:UIImageView!
    @IBOutlet weak var lbl_user_name:UILabel!
    @IBOutlet weak var lbl_time:UILabel!
    
    @IBOutlet weak var lbl_title:UILabel!
    @IBOutlet weak var lbl_category:UILabel!
    @IBOutlet weak var img_annoucement:UIImageView!
    @IBOutlet weak var lbl_description:UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if get_details!.user.count > 0 {
            lbl_user_name.text = get_details!.user[0].userName
            let userProfile = k_Base_URL_Imgae+get_details!.user[0].userProfile
            img_user_profile.sd_setImage(with: URL(string:userProfile), placeholderImage:k_default_user)
        } else {
            lbl_user_name.text = ""
            img_user_profile.image = k_default_user
        }
        
        lbl_time.text = get_details!.created.UTCToLocal
        
        lbl_category.text = get_details!.category[0].categoryName
        
        let announcementImage = k_Base_URL_Imgae+get_details!.announcementImage
        img_annoucement.sd_setImage(with: URL(string:announcementImage), placeholderImage:nil)
        lbl_description.text = get_details!.announcementDesc
    }
    
    @IBAction func btn_repost(_ sender:UIButton) {
        let storyboard = UIStoryboard (name: "Main_1", bundle: nil)
        let announcement_details_VC = storyboard.instantiateViewController(withIdentifier:"New_Post_VC") as! New_Post_VC
        announcement_details_VC.is_repost = true
        navigationController?.pushViewController(announcement_details_VC, animated: true)
    }
    
    @IBAction func btn_delete(_ sender:UIButton) {
        let storyboard = UIStoryboard (name: "PopUp", bundle: nil)
        let delete_Sure_VC = storyboard.instantiateViewController(withIdentifier: "Delete_Sure_VC") as! Delete_Sure_VC
        delete_Sure_VC.delegate = self
        
        self.addChild(delete_Sure_VC)
        
//        delete_Sure_VC.view.center = view.center
//        delete_Sure_VC.view.alpha = 0
        delete_Sure_VC.view.transform = CGAffineTransform(scaleX:2, y:2)
        
        self.view.addSubview(delete_Sure_VC.view)
        UIView.animate(withDuration:0.2, delay: 0, usingSpringWithDamping:0.7, initialSpringVelocity: 0, options: [],  animations: {
            delete_Sure_VC.view.transform = .identity
        })
        
    }
    
    func func_Yes() {
        let param = [
            "announcement_id":get_details?.announcementID] as! [String:String]
        print(param)
        
        let hud = KRProgressHUD.showOn(self)
        hud.show()
        APIFunc.postAPI("announcement_delete", param) { (json, status, message) in
            DispatchQueue.main.async {
                hud.dismiss()
                if status == success_resp {
                    self.funcDeletedMessage("Your post has been", "", "deleted!")
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                        hud.showError(withMessage: message)
                    }
                }
            }
        }
        
    }
    
    func func_No() {
        
    }
    
}
