//  MeetWtihViewController.swift
//  SheDistrict
//  Created by Appentus Technologies on 2/7/20.
//  Copyright © 2020 appentus. All rights reserved.


import UIKit
import CoreLocation
import KRProgressHUD


protocol DelegateMeetWith {
    func funcDoneDelegateMeetWith(_ userNames:String,_ userIDs:String)
}


class MeetWtihViewController: UIViewController {
    @IBOutlet weak var tblMeetWith:UITableView!
    @IBOutlet weak var heightTblMeetWith:NSLayoutConstraint!
    
    var delegate:DelegateMeetWith?
    
    var co_OrdinateCurrent = CLLocationCoordinate2DMake(0.0, 0.0)
    var locationManager = CLLocationManager()
    var is_location = false
    
    var strUserNames = ""
    var strUserIDs = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.heightTblMeetWith.constant = 0
        func_core_location()
    }
    
    @IBAction func btnCancel(_ sender:Any) {
        func_removeFromSuperview()
    }
    
    @IBAction func btnDone(_ sender:Any) {
        let arrIndexpaths = tblMeetWith.indexPathsForSelectedRows
        if arrIndexpaths == nil {
            return
        }
        
        for i in arrIndexpaths! {
            if strUserNames.isEmpty {
                strUserNames.append(getFriendList[i.row].userName)
                strUserIDs.append(getFriendList[i.row].userID)
            } else {
                strUserNames.append(","+getFriendList[i.row].userName)
                strUserIDs.append(","+getFriendList[i.row].userID)
            }
        }
                
        func_removeFromSuperview()
        delegate?.funcDoneDelegateMeetWith(strUserNames, strUserIDs)
    }
    
}



extension MeetWtihViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getFriendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = getFriendList[indexPath.row].userName
        cell.textLabel?.font = UIFont (name:"Roboto-Light", size: 16)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let arrIndexpaths = tblMeetWith.indexPathsForSelectedRows
        if arrIndexpaths!.count > 40 {
            tblMeetWith.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {

    }
    
}

extension MeetWtihViewController:CLLocationManagerDelegate {
    func func_core_location() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        co_OrdinateCurrent = manager.location!.coordinate
        
        if !is_location {
            is_location = true
            func_get_friend_list()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
        
    func func_get_friend_list() {
        let hud = KRProgressHUD.showOn(self)
        hud.show()
        
        let param = ["user_lat":"\(co_OrdinateCurrent.latitude)","user_lang":"\(co_OrdinateCurrent.longitude)"]
        APIFunc.postAPI("get_friend_list",param) { (json,status,message)  in
            DispatchQueue.main.async {
                hud.dismiss()
                
                let status = return_status(json.dictionaryObject!)
                switch status {
                case .success:
                    let decoder = JSONDecoder()
                    if let jsonData = json[result_resp].description.data(using: .utf8) {
                        do {
                            getFriendList = try decoder.decode([GetFriendList].self, from: jsonData)
                            let heightCalculation = CGFloat(60*getFriendList.count)
                            if heightCalculation < 100 {
                                self.heightTblMeetWith.constant = heightCalculation
                            } else if heightCalculation > 460 {
                                self.heightTblMeetWith.constant = 460
                            }
                            
                            UIView.animate(withDuration: 0.4) {
                                self.view.layoutIfNeeded()
                            }
                            self.tblMeetWith.reloadData()
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

