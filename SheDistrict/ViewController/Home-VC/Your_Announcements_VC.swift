//  Your_Announcements_VC.swift
//  SheDistrict
//  Created by appentus on 1/6/20.
//  Copyright © 2020 appentus. All rights reserved.


import UIKit
import KRProgressHUD


class Your_Announcements_VC: UIViewController {
    @IBOutlet weak var tbl_func_my_announcements:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getAnnouncement.removeAll()
        func_my_announcements_API()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        getAnnouncement.removeAll()
    }
    
    func func_my_announcements_API() {
        let hud = KRProgressHUD.showOn(self)
        hud.show()
        
        APIFunc.postAPI("my_announcements", ["user_id":signUp!.userID]) { (json,status,message) in
            DispatchQueue.main.async {
                hud.dismiss()
                
                let status = return_status(json.dictionaryObject!)
                switch status {
                case .success:
                    let decoder = JSONDecoder()
                    if let jsonData = json[result_resp].description.data(using: .utf8) {
                        do {
                            getAnnouncement = try decoder.decode([GetAnnouncement].self, from: jsonData)
                            self.tbl_func_my_announcements.reloadData()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                case .fail:
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                        hud.showError(withMessage: "\(json["message"])")
                    })
                case .error_from_api:
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                        hud.showError(withMessage:"error_message")
                    })
                }
            }
        }
        
    }
    
}



extension Your_Announcements_VC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getAnnouncement.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"cell", for: indexPath) as! Your_Announcement_TableCell
        
        let announcementImage = k_Base_URL_Imgae+getAnnouncement[indexPath.row].announcementImage
        cell.img_user_profile.sd_setImage(with: URL(string:announcementImage), placeholderImage:k_default_user)
        
        cell.lbl_user_name.text = getAnnouncement[indexPath.row].announcementTitle
        cell.lbl_time.text = getAnnouncement[indexPath.row].created.UTCToLocal
        
        cell.btn_view.tag = indexPath.row
        cell.btn_view.addTarget(self, action: #selector(btn_view(_:)), for:.touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        
        UIView.animate(withDuration:0.25, delay:0.01, animations: {
            cell.alpha = 1
        })
    }
    
    @IBAction func btn_view(_ sender:UIButton) {
        get_details = getAnnouncement[sender.tag]
        func_Next_VC_Main_1("Announcement_Details_VC")
    }
    
}


