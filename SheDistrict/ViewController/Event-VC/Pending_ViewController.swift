//  Pending_ViewController.swift
//  SheDistrict
//  Created by appentus on 1/9/20.
//  Copyright © 2020 appentus. All rights reserved.


import UIKit
import SDWebImage
import KRProgressHUD


class Pending_ViewController: UIViewController {
    @IBOutlet weak var tblPendingEvent:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        func_get_events()
    }
    
    func func_get_events() {
        let param = ["user_id":signUp!.userID]
        print(param)
        
        let hud = KRProgressHUD.showOn(self)
        hud.show()
        APIFunc.postAPI("get_events", param) { (json,status,message) in
            DispatchQueue.main.async {
                hud.dismiss()
                
                let status = return_status(json.dictionaryObject!)
                switch status {
                case .success:
                    let decoder = JSONDecoder()
                    if let jsonData = json["pending"].description.data(using: .utf8) {
                        do {
                            scheduleEvents = try decoder.decode([ScheduleEvents].self, from: jsonData)
                            self.tblPendingEvent.reloadData()
                        } catch {
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                                hud.showError(withMessage: "\(error.localizedDescription)")
                            })
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



extension Pending_ViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduleEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"cell", for: indexPath) as! PendingEvent_TableCell
        
        let pendings = scheduleEvents[indexPath.row]
        cell.imgUserProfile.sd_setImage(with: URL(string:k_Base_URL_Imgae+(pendings.userProfile ?? "")), placeholderImage:k_default_user)
        
        let attrUserNameInvited = func_attributed_text(UIColor .black, UIColor.lightGray,UIFont (name:"Roboto-Regular", size:16.0)!, UIFont (name:"Roboto-Light", size:16.0)!,pendings.userName ?? "", " \(pendings.text ?? "")")
        cell.lblUserNameInvited.attributedText = attrUserNameInvited
        cell.lblTime.text = pendings.meetingTime
        
        cell.btnView.tag = indexPath.row
        cell.btnView.addTarget(self, action:#selector(btnView(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let animation = AnimationFactory.makeSlideIn(duration:0.25, delayFactor:0.01)
        let animator = Animator(animation: animation)
        animator.animate(cell: cell, at: indexPath, in: tableView)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    @IBAction func btnView(_ sender:UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name (rawValue:"YouveBeenInvited"), object: nil)
        pendingEventSelected = scheduleEvents[sender.tag]
    }
    
}


