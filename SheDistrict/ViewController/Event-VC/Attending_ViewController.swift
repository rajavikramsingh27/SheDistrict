//  Attending_ViewController.swift
//  SheDistrict
//  Created by appentus on 1/9/20.
//  Copyright © 2020 appentus. All rights reserved.


import UIKit
import KRProgressHUD


class Attending_ViewController: UIViewController {
    @IBOutlet weak var tbl_attending_event:UITableView!
    var arr_select_attend_event = [[Bool]]()
    
    var eventsYesterday:[ScheduleEvents] = []
    var eventsToday:[ScheduleEvents] = []
    var eventsUpcoming:[ScheduleEvents] = []
    
    var eventType = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        func_get_events()
    }
    
    func funcSetEvents() {
        var arr_select_attend_event_row = [Bool]()
        
        for i in 0..<3 {
            arr_select_attend_event_row = [Bool]()
            
            if i == 0 {
                for _ in 0..<eventsYesterday.count {
                    arr_select_attend_event_row.append(false)
                }
                arr_select_attend_event.append(arr_select_attend_event_row)
            } else if i == 1 {
                for _ in 0..<eventsToday.count {
                    arr_select_attend_event_row.append(false)
                }
                arr_select_attend_event.append(arr_select_attend_event_row)
            } else if i == 2 {
                for _ in 0..<eventsUpcoming.count {
                    arr_select_attend_event_row.append(false)
                }
                arr_select_attend_event.append(arr_select_attend_event_row)
            }
        }
        print(arr_select_attend_event)
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
                    if let jsonData = json["attending"].description.data(using: .utf8) {
                        do {
                            scheduleEvents = try decoder.decode([ScheduleEvents].self, from: jsonData)
                            
                            for scheduleEvent in scheduleEvents {
                                let dayPostition = scheduleEvent.meetingDate?.dateDifference().day
                                if dayPostition! < 0 {
                                    self.eventsYesterday.append(scheduleEvent)
                                } else if dayPostition! == 0 {
                                    self.eventsToday.append(scheduleEvent)
                                } else if dayPostition! > 0 {
                                    self.eventsUpcoming.append(scheduleEvent)
                                }
                            }
                            
                            self.eventType = ["Yesterday","Today","Upcoming"]
                            self.funcSetEvents()
                            self.tbl_attending_event.reloadData()
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



extension Attending_ViewController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return eventType.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier:"cell-header") as! Attending_Header_TableCell
        
        cell.lbl_title?.text = eventType[section]
        if section == 0 {
//            cell.lbl_title?.text = "Yesterday"
            cell.lbl_title?.textColor = hexStringToUIColor("E1E1E1")
        } else if section == 1 {
//            cell.lbl_title?.text = "Today"
            cell.lbl_title?.textColor = hexStringToUIColor("5B6DEC")
        } else {
//            cell.lbl_title?.text = "Upcoming"
            cell.lbl_title?.textColor = UIColor .black
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return arr_select_attend_event[indexPath.section][indexPath.row] ? 180 : 95
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_select_attend_event[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"cell", for: indexPath) as! Attending_Events_TableCell
        
        cell.btn_arrow.isSelected = arr_select_attend_event[indexPath.section][indexPath.row]
        
        cell.view_details_container.isHidden = !arr_select_attend_event[indexPath.section][indexPath.row]
        
        cell.btn_select.tag = indexPath.row
        cell.btn_select.addTarget(self, action: #selector(btn_select(_:)), for: .touchUpInside)
                
//        0=pending 1=accept 2= deny 3=later
        var eventSection:ScheduleEvents!
        if indexPath.section == 0 {
            eventSection = eventsYesterday[indexPath.row]
            if eventSection.meetingStatus == "0" {
                cell.lbl_attended.text = "Pending"
            } else if eventSection.meetingStatus == "1" {
                cell.lbl_attended.text = "Attended"
            } else if eventSection.meetingStatus == "2" {
                cell.lbl_attended.text = "Denied"
            } else if eventSection.meetingStatus == "3" {
                cell.lbl_attended.text = "Later"
            } else {
                cell.lbl_attended.text = "Invalid Status"
            }
        } else if indexPath.section == 1 {
            eventSection = eventsToday[indexPath.row]
        } else {
            eventSection = eventsUpcoming[indexPath.row]
        }
        
        cell.imgProfileUser.sd_setImage(with: URL(string:k_Base_URL_Imgae+(eventSection.userProfile ?? "")), placeholderImage:k_default_user)
        
        cell.lblText.text = eventSection.text ?? ""
        cell.lblWeVeBeenVeryGoodInternet.text = "We've been very good internet friends \(eventSection.userName ?? ""), let's meet!"
        cell.lblLocation.text = eventSection.meetingLocation ?? ""
        cell.lblDate.text = eventSection.meetingDate ?? ""
        cell.lblTime.text = eventSection.meetingTime ?? ""
        cell.lblText.text = eventSection.text ?? ""
                
        if indexPath.section == 0 {
            cell.lbl_attended.text = "Attended"
        } else if indexPath.section == 1 {
            cell.lbl_attended.text = "Meeting in 7 hours"
        } else {
            cell.lbl_attended.text = "Meeting in 2 days"
        }
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let animation = AnimationFactory.makeSlideIn(duration:0.3, delayFactor: 0.05)
//        let animator = Animator(animation: animation)
//        animator.animate(cell: cell, at: indexPath, in: tableView)
//    }
    
    @IBAction func btn_select(_ sender:UIButton) {
        let pointInTable = sender.convert(sender.bounds.origin, to:tbl_attending_event)
        let indexPath = self.tbl_attending_event.indexPathForRow(at: pointInTable)
        
        for i in 0..<arr_select_attend_event.count {
            let arrSelectAttendEvent = arr_select_attend_event[i]
            if i == indexPath?.section {
                for j in 0..<arrSelectAttendEvent.count {
                    if j == indexPath?.row {
                        if arr_select_attend_event[i][j] {
                            arr_select_attend_event[i][j] = false
                        } else {
                            arr_select_attend_event[i][j] = true
                        }
                    } else {
                        arr_select_attend_event[i][j] = false
                    }
                }
            } else {
                let arrSelectAttendEvent = arr_select_attend_event[i]
                for j in 0..<arrSelectAttendEvent.count {
                    arr_select_attend_event[i][j] = false
                }
            }
        }
        tbl_attending_event.reloadData()
    }
    
}


