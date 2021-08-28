//  Add_Event_ViewController.swift
//  SheDistrict
//  Created by appentus on 1/10/20.
//  Copyright © 2020 appentus. All rights reserved.


protocol Delegate_Add_Event {
    func func_rules_tips()
    func func_send_invitation(_ message:String)
    func func_rules_nevermind()
}



import UIKit
import DropDown
import KRProgressHUD
import CoreLocation



class Add_Event_ViewController: UIViewController,DelegateMeetWith {
    @IBOutlet weak var scroll_View:UIScrollView!
    
    @IBOutlet var text_field:[UITextField]!
    @IBOutlet var view_field:[UIView]!
    
    var hours = "00"
    var minute = "00"
    
    let year_drown = DropDown()
    let month_drown = DropDown()
    let days_drown = DropDown()
    let am_pm_drown = DropDown()
    
    var picker_Time = UIPickerView()
    
    var arr_min = [String]()
    var arr_hour = [String]()
    
    var delegate:Delegate_Add_Event?
        
    var arrSelectedFriend = [String]()
    
    var userIdsMeetWith = ""
    var monthPram = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        funcSetUI()
    }
    
    func funcSetUI() {
        for i in 1...12 {
            self.arr_hour.append("\(i)")
        }
        
        for i in 0..<60 {
            self.arr_min.append("\(i)")
        }
        
        scroll_View.layer.cornerRadius = 10
        scroll_View.clipsToBounds = true
        
        for i in 0..<text_field.count {
            text_field[i].tag = i
            text_field[i].delegate = self
        }
        
        picker_Time.delegate = self
        picker_Time.dataSource = self
        
        text_field[6].inputView = picker_Time
        picker_Time.selectedRow(inComponent: 0)
        
        func_days_drop_down()
        func_month_drop_down()
        func_year_drop_down()
        func_am_pm_drop_down()
    }
    
    @objc func func_date_picker(_ sender:UIDatePicker) {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "h:mm a"
        
        text_field[6].text = dateformatter.string(from:sender.date).components(separatedBy: " ")[0]
        text_field[7].text = dateformatter.string(from:sender.date).components(separatedBy: " ")[1]
    }
    
    @IBAction func btnMeetWith(_ sender:UIButton) {
        let storyboard = UIStoryboard (name: "PopUp", bundle: nil)
        let meetWithVC = storyboard.instantiateViewController(withIdentifier: "MeetWtihViewController") as! MeetWtihViewController
        meetWithVC.delegate = self
        self.addChild(meetWithVC)
        
        meetWithVC.view.transform = CGAffineTransform(scaleX:2, y:2)
        
        self.view.addSubview(meetWithVC.view)
        UIView.animate(withDuration:0.2, delay: 0, usingSpringWithDamping:0.7, initialSpringVelocity: 0, options: [],  animations: {
            meetWithVC.view.transform = .identity
        })
    }
    
    func funcDoneDelegateMeetWith(_ userNames:String, _ userIDs:String) {
        text_field[0].text = userNames
        userIdsMeetWith = userIDs
    }
    
    @IBAction func btn_cancel(_ sender:UIButton) {
        func_removeFromSuperview()
    }
    
    @IBAction func btn_send_invitation(_ sender:UIButton) {
        if !funcValidation() {
            return
        }
//        func_removeFromSuperview()
//        delegate?.func_send_invitation()
        func_schedule_meeting()
    }
    
    @IBAction func btn_nevermind(_ sender:UIButton) {
        func_removeFromSuperview()
        delegate?.func_rules_nevermind()
    }
    
    @IBAction func btn_rules_tips(_ sender:UIButton) {
        func_removeFromSuperview()
        delegate?.func_rules_tips()
    }
            
    private func funcValidation() -> Bool {
        var is_valid = false
        for i in 0..<text_field.count {
            if text_field[i].text!.isEmpty {
                view_field[i].shake()
                view_field[i].funcErrorShadowScheduleMetting()
                
                is_valid = false
                break
            } else {
                view_field[i].funcRemoveShadowScheduleMetting()
                is_valid = true
            }
        }
        
        return is_valid
    }
        
    func func_schedule_meeting() {
        let hud = KRProgressHUD.showOn(self)
        hud.show()
        
        let meeting_date = "\(text_field[5].text!)/\(monthPram)/\(text_field[3].text!)"
        let meeting_time = "\(text_field[6].text!) \(text_field[7].text!)"
        
        let param = [
                        "meeting_user_id":signUp!.userID,
                        "meeting_friend_id":userIdsMeetWith,
                        "meeting_subject":text_field[1].text!,
                        "meeting_reason":text_field[2].text!,
                        "meeting_date":meeting_date,
                        "meeting_time":meeting_time,
                        "meeting_location":text_field[8].text!
                    ]
        print(param)
        
//        ["meeting_user_id": "164", "meeting_subject": "sujsjs", "meeting_location": "jaipur ", "meeting_reason": "hshssuss", "meeting_date": "2017/08/08", "meeting_friend_id": "51,60,75,77,78", "meeting_time": "02:00 PM"]

        APIFunc.postAPI("schedule_meeting",param) { (json,status,message)  in
            DispatchQueue.main.async {
                hud.dismiss()
                
                let status = return_status(json.dictionaryObject!)
                switch status {
                case .success:
                    self.func_removeFromSuperview()
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.4, execute: {
                        self.delegate?.func_send_invitation(message)
                    })
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

extension Add_Event_ViewController:UITextFieldDelegate ,UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0{
            return arr_hour.count
        }else if component == 1{
            return 1
        }else if component == 2{
            return arr_min.count
        }else{
            return 1
        }
       
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0{
            return arr_hour[row]
        }else if component == 1{
            return "Hour"
        }else if component == 2{
            return arr_min[row]
        }else {
            return "Minute"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            if row < 10 {
                hours = "0\(arr_hour[row])"
            } else {
                hours = "\(arr_hour[row])"
            }
        } else if component == 2{
            if row < 10 {
                minute = "0\(arr_min[row])"
            } else {
                minute = "\(arr_min[row])"
            }
        }
        text_field[6].text = "\(hours):\(minute)"
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if component == 0{
            return 50
        } else if component == 1{
            return 80
        } else if component == 2{
            return 50
        } else{
            return 80
        }
    }
        
    func func_year_drop_down() {
        var arr_year = [String]()
        
        for i in 1900...2019 {
            arr_year.append("\(i)")
        }
        
        arr_year = arr_year.reversed()
        
        year_drown.dismissMode = .manual
        year_drown.backgroundColor = UIColor.white
        
        year_drown.anchorView = text_field[5]
        year_drown.bottomOffset = CGPoint(x: 0, y:text_field[5].bounds.height)
        year_drown.dataSource = arr_year
        
        year_drown.selectionAction = { [weak self] (index, item) in
            self?.text_field[5].text = item
        }
    }
    
    func func_month_drop_down() {
        let arrMonth = ["01","02","03","04","05","06","07","08","09","10","11","12"]
        
        month_drown.dismissMode = .manual
        month_drown.backgroundColor = UIColor.white
        
        month_drown.anchorView = text_field[4]
        month_drown.bottomOffset = CGPoint(x: 0, y: text_field[4].bounds.height)
        month_drown.dataSource = [
            "January","February","March","April","May","June","July","august","September","October","November","December"
        ]
        
        month_drown.selectionAction = { [weak self] (index, item) in
            self?.text_field[4].text = item
            self!.monthPram = arrMonth[index]
        }
        
    }
    
    func func_days_drop_down() {
        var arr_day = [String]()
        
        for i in 1...31 {
            if i < 10 {
                arr_day.append("0\(i)")
            } else {
                arr_day.append("\(i)")
            }
        }
        
        days_drown.dismissMode = .manual
        days_drown.backgroundColor = UIColor.white
        
        days_drown.anchorView = text_field[3]
        days_drown.bottomOffset = CGPoint(x: 0, y: text_field[3].bounds.height)
        days_drown.dataSource = arr_day
        days_drown.selectionAction = { [weak self] (index, item) in
            self?.text_field[3].text = item
        }
        
    }
    
    func func_am_pm_drop_down() {
        let arr_year = ["AM","PM"]
        
        am_pm_drown.dismissMode = .manual
        am_pm_drown.anchorView = text_field[7]
        am_pm_drown.bottomOffset = CGPoint(x: 0, y:text_field[7].bounds.height)
        am_pm_drown.dataSource = arr_year
        
        am_pm_drown.selectionAction = { [weak self] (index, item) in
            self?.text_field[7].text = item
        }
    }
     
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        for view in view_field {
            view.funcRemoveShadowScheduleMetting()
        }
        
        if textField.tag == 0 {
            
            return false
        } else if 3 == textField.tag {
            days_drown.show()
            return false
        } else if 4 == textField.tag {
            month_drown.show()
            return false
        } else if 5 == textField.tag {
            year_drown.show()
            return false
        } else if 7 == textField.tag {
            am_pm_drown.show()
            return false
        } else {
            return true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        for i in 0..<text_field.count {
            if i+1 == textField.tag {
                if text_field[i].text!.isEmpty {
                    
                } else {
                    
                }
            }
        }
    }
    
}

