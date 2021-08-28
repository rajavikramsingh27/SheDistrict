//  Edit_Profile_ViewController.swift
//  SheDistrict
//  Created by appentus on 1/13/20.
//  Copyright © 2020 appentus. All rights reserved.


import UIKit
import DropDown
import KRProgressHUD


var placeHolderAboutMe = "Enter about me"
var placeHolderImLookingForFriendsWho = "Enter I'm looking for friends who"

var dictInterest = [String:Any]()

class Edit_Profile_ViewController: UIViewController {
    @IBOutlet weak var btnSaveHobbiesInterest:UIButton!
    
    @IBOutlet weak var txt_about_me:UITextView!
    @IBOutlet weak var txt_search:UITextField!
    @IBOutlet weak var txt_i_am_lookin_for_friends:UITextView!
    @IBOutlet weak var view_light_shadow:UIView!
    
    @IBOutlet weak var view_info:UIView!
    @IBOutlet weak var viewSearchInfo:UIView!
    @IBOutlet weak var tbl_profile_details:UITableView!
    @IBOutlet var btn_personal_info:[UIButton]!
    
    let arr_hobbies = ["Antiquing","Archery","Astrology","Baking","Beatboxing","Beer tasting","Birdwatching","Bowling","Brewling beer"]
    let arr_interests = ["Favorite Food","Favorite Color","Favorite Music Genre","Favorite Movie Genre","Favorite Type of Clothing","Favorite Season","Favorite Animal","Favorite App","Favorite Car"]
    
    var is_interests = false
    
    let dropDownInterest = DropDown()
    let dropDownDescribeMe = DropDown()
    
    var arrValueInterest = [ValueInterest]()
    var arrHobies = [[String:Any]]()
    var arrDescribeMeSelected = [[String:Any]]()
    
    var keyInterestInfo = ""
        
    var arrSearched = [GetHobby]()
    var arrForSearch = [GetHobby]()
    
    var arrSelected = [Bool]()
    var arrSelectedHobbies = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0..<btn_personal_info.count {
            btn_personal_info[i].tag = i+1
            btn_personal_info[i].addTarget(self, action: #selector(btnHobbiesInterests), for:.touchUpInside)
        }
        
        for i in 0..<btn_personal_info.count {
            if i+1 == 1 {
                btn_personal_info[i].setTitleColor(UIColor .black, for: .normal)
            } else {
                btn_personal_info[i].setTitleColor(UIColor .gray, for: .normal)
            }
        }
        
        func_add_info()
        funcSetUI()
    }
        
    func funcSetUI() {
        txt_about_me.text = signUp!.aboutMe
        txt_i_am_lookin_for_friends.text = signUp!.friendLike
        
        if txt_about_me.text.isEmpty {
            txt_about_me.text = placeHolderAboutMe
            txt_about_me.textColor = UIColor.lightGray
        }
        
        if txt_i_am_lookin_for_friends.text.isEmpty {
            txt_i_am_lookin_for_friends.text = placeHolderImLookingForFriendsWho
            txt_i_am_lookin_for_friends.textColor = UIColor.lightGray
        }
    }
    
    func func_add_info() {
        view_info.frame = self.view.frame
        self.view.addSubview(view_info)
        
        view_info.isHidden = true
    }
    
    @IBAction func btnPersonalInfo(_ sender:UIButton) {
        let storyboard = UIStoryboard (name: "PopUp", bundle: nil)
        let personalInfoVC = storyboard.instantiateViewController(withIdentifier: "PersonalInfoViewController") as! PersonalInfoViewController
        self.addChild(personalInfoVC)
        
        personalInfoVC.view.transform = CGAffineTransform(scaleX:2, y:2)
        
        self.view.addSubview(personalInfoVC.view)
        UIView.animate(withDuration:0.2, delay: 0, usingSpringWithDamping:0.7, initialSpringVelocity: 0, options: [],  animations: {
            personalInfoVC.view.transform = .identity
        })
    }
    
    @IBAction func btnUploadPhotos(_ sender:UIButton) {
        let storyboard = UIStoryboard (name:"Main", bundle:nil)
        let createYourProfileVC = storyboard.instantiateViewController(withIdentifier:"Upload_Photos_VC") as! Upload_Photos_VC
        createYourProfileVC.isEditProfile = true
        self.navigationController?.pushViewController(createYourProfileVC, animated:true)
    }
    
    @IBAction func btnCreateUpload(_ sender:UIButton) {
        let storyboard = UIStoryboard (name:"Main", bundle:nil)
        let createYourProfileVC = storyboard.instantiateViewController(withIdentifier:"Create_Your_Profile_VC") as! Create_Your_Profile_VC
        createYourProfileVC.isEditProfile = true
        self.navigationController?.pushViewController(createYourProfileVC, animated:true)
    }
    
    @IBAction func btnChangeUserNamePassword(_ sender:UIButton) {
        func_Next_VC_Main_3("Change_Name_Password_VC")
    }
    
    @IBAction func btn_info(_ sender:UIButton) {
        arrSelected.removeAll()
        arrSelectedHobbies.removeAll()
        
        func_get_hobbies()
        view_info.isHidden = false
        view_info.transform = CGAffineTransform(scaleX:2, y:2)
        UIView.animate(withDuration:0.2, delay: 0, usingSpringWithDamping:0.7, initialSpringVelocity: 0, options: [],  animations: {
            self.view_info.transform = .identity
        })
    }
    
    @IBAction func btn_cancel(_ sender:UIButton) {
        arrHobies.removeAll()
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping:0.5, initialSpringVelocity: 0, options: [], animations: {
            self.view_info.transform = CGAffineTransform(scaleX:0.02, y: 0.02)
        }) { (success) in
            self.view_info.isHidden = true
        }
    }
    
    @IBAction func btnHobbiesInterests(_ sender:UIButton) {
        var frameSearch = viewSearchInfo.frame
        
        for i in 0..<btn_personal_info.count {
            if i+1 == sender.tag {
                btn_personal_info[i].setTitleColor(UIColor .black, for: .normal)
                if sender.tag == 1 {
                    is_interests = false
                    txt_search.placeholder = "Search for hobbies"
                    view_light_shadow.isHidden = true
                    frameSearch.size.height = 55
                    func_get_hobbies()
                    btnSaveHobbiesInterest.tag = 1
                } else {
                    is_interests = true
                    txt_search.placeholder = "Search for interests"
                    view_light_shadow.isHidden = false
                    frameSearch.size.height = 0
                    func_get_interest()
                    btnSaveHobbiesInterest.tag = 2
                }
            } else {
                btn_personal_info[i].setTitleColor(UIColor .gray, for: .normal)
            }
        }
        viewSearchInfo.frame = frameSearch
    }
    
}



extension Edit_Profile_ViewController:UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == txt_about_me {
            if txt_about_me.text == placeHolderAboutMe {
                txt_about_me.textColor = UIColor.black
                txt_about_me.text = ""
            }
        } else if textView == txt_i_am_lookin_for_friends {
            if txt_i_am_lookin_for_friends.text == placeHolderImLookingForFriendsWho {
                txt_i_am_lookin_for_friends.textColor = UIColor.black
                txt_i_am_lookin_for_friends.text = ""
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == txt_about_me {
            if txt_about_me.text == "" {
                txt_about_me.textColor = UIColor.lightGray
                txt_about_me.text = placeHolderAboutMe
            }
        } else if textView == txt_i_am_lookin_for_friends {
            if txt_i_am_lookin_for_friends.text == "" {
                txt_i_am_lookin_for_friends.textColor = UIColor.lightGray
                txt_i_am_lookin_for_friends.text = placeHolderImLookingForFriendsWho
            }
        }
    }
    
    
}



extension Edit_Profile_ViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if is_interests {
            return 55
        } else {
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if is_interests {
            return getInterest.count
        } else {
            return getHobbies.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if is_interests {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell-1", for: indexPath)
            
            let btn_interests = cell.viewWithTag(1) as? UIButton
            btn_interests?.setTitle(getInterest[indexPath.row].interest, for: .normal)
            
            btn_interests?.tag = indexPath.row
            btn_interests?.addTarget(self, action:#selector(btnDropDownInterest(_:)), for:.touchUpInside)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            let lbl_left = cell.viewWithTag(1) as? UILabel
            lbl_left?.text = getHobbies[indexPath.row].hibbiesName
            
//            let selectedView = UIView()
//            selectedView.backgroundColor = hexStringToUIColor("ECE9EE")
//            cell.selectedBackgroundView = selectedView
            
            let btnSelectHobbies = cell.viewWithTag(2) as? UIButton
            btnSelectHobbies?.tag = indexPath.row
            btnSelectHobbies?.addTarget(self, action:#selector(btnSelectHobies), for:.touchUpInside)
            
            let viewSelected = cell.viewWithTag(3)
//            if arrSelected[indexPath.row] {
//                viewSelected?.backgroundColor = hexStringToUIColor("ECE9EE")
//            } else {
//                viewSelected?.backgroundColor = UIColor .white
//            }
            
            if arrSelectedHobbies.contains(getHobbies[indexPath.row].hibbiesName) {
                viewSelected?.backgroundColor = hexStringToUIColor("ECE9EE")
            } else {
                viewSelected?.backgroundColor = UIColor .white
            }
            
            return cell
        }
        
    }
        
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let animation = AnimationFactory.makeSlideIn(duration:0.2, delayFactor:0.001)
//        let animator = Animator(animation: animation)
//        animator.animate(cell: cell, at: indexPath, in: tableView)
    }
     
    @IBAction func btnSelectHobies(_ sender:UIButton) {
        for i in 0..<arrSelected.count {
            if i == sender.tag {
                if arrSelected[i] {
                    arrSelected[i] = false
                    if arrSelectedHobbies.contains(getHobbies[i].hibbiesName) {
                        arrSelectedHobbies.remove(at:arrSelectedHobbies.firstIndex(of:getHobbies[i].hibbiesName)!)
                    }
                } else {
                    arrSelected[i] = true
                    if !arrSelectedHobbies.contains(getHobbies[i].hibbiesName) {
                        arrSelectedHobbies.append(getHobbies[i].hibbiesName)
                    }
                }
            }
        }
        
        tbl_profile_details.reloadData()
    }
    
    @IBAction func btnDropDownInterest(_ sender:UIButton) {
        keyInterestInfo = getInterest[sender.tag].interest
        funcDropDownInterest(sender.tag)
    }
    
}



import KRProgressHUD
// MARK:- api methods
extension Edit_Profile_ViewController {
    func func_get_hobbies() {
        self.tbl_profile_details.allowsMultipleSelection = true
        
        if getHobbies.count == 0 {
            let hud = KRProgressHUD.showOn(self)
            hud.show(withMessage: "Loading...")
//            hud.show()
            APIFunc.getAPI("get_hobbies", [:]) { (json, status, message) in
                DispatchQueue.main.async {
                    hud.dismiss()
                    if status == success_resp {
                        let decoder = JSONDecoder()
                        if let jsonData = json[result_resp].description.data(using: .utf8) {
                            do {
                                getHobbies = try decoder.decode([GetHobby].self, from: jsonData)
                                self.arrForSearch = getHobbies
                                for _ in getHobbies {
                                    self.arrSelected.append(false)
                                }
                                self.tbl_profile_details.reloadData()
                            } catch {
                                DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                                    hud.showError(withMessage: "\(error.localizedDescription)")
                                })
                            }
                        }
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                            hud.showError(withMessage: message)
                        }
                    }
                }
            }
        } else {
            self.arrForSearch = getHobbies
            for _ in getHobbies {
                self.arrSelected.append(false)
            }
            self.tbl_profile_details.reloadData()
        }

    }
    
    func func_get_interest() {
        self.tbl_profile_details.allowsMultipleSelection = false
        
        if getInterest.count == 0 {
            let hud = KRProgressHUD.showOn(self)
            hud.show()
            APIFunc.getAPI("get_interest",[:]) { (json, status, message) in
                DispatchQueue.main.async {
                    hud.dismiss()
                    if status == success_resp {
                        let decoder = JSONDecoder()
                        if let jsonData = json[result_resp].description.data(using: .utf8) {
                            do {
                                getInterest = try decoder.decode([GetInterest].self, from: jsonData)
                                
                                for getInterestData in getInterest {
                                    dictInterest[getInterestData.interest] = ""
                                }
                                self.tbl_profile_details.reloadData()
                            } catch {
                                DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                                    hud.showError(withMessage: "\(error.localizedDescription)")
                                })
                            }
                        }
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                            hud.showError(withMessage: message)
                        }
                    }
                }
            }
        } else {
            for getInterestData in getInterest {
                dictInterest[getInterestData.interest] = ""
            }
            self.tbl_profile_details.reloadData()
        }
        
    }
        
    func func_describe_data(_ sender:UIButton) {
        let hud = KRProgressHUD.showOn(self)
        hud.show()
        APIFunc.getAPI("describe_data",[:]) { (json, status, message) in
            DispatchQueue.main.async {
                hud.dismiss()
                if status == success_resp {
                    let decoder = JSONDecoder()
                    if let jsonData = json[result_resp].description.data(using: .utf8) {
                        do {
                            describeMe = try decoder.decode([DescribeMe].self, from: jsonData)
                            self.funcDropDownDescribeMe(sender)
                        } catch {
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                                hud.showError(withMessage: "\(error.localizedDescription)")
                            })
                        }
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                        hud.showError(withMessage: message)
                    }
                }
            }
        }
    }
    
    @IBAction func btnSaveHobbiesInterest(_ sender:UIButton) {
        if sender.tag == 2 {
                
        } else {
            for i in 0..<arrSelected.count {
                let dictHobies = [
                    "hobbies_id":getHobbies[i].hobbiesID,
                    "hibbies_name":getHobbies[i].hibbiesName,
                    "created":getHobbies[i].created.UTCToLocal
                ]
                arrHobies.append(dictHobies)
            }
        }
        
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping:0.5, initialSpringVelocity: 0, options: [], animations: {
            self.view_info.transform = CGAffineTransform(scaleX:0.02, y: 0.02)
        }) { (success) in
            self.view_info.isHidden = true
        }
    }
    
}

//MARK:-  save profile
extension Edit_Profile_ViewController {    
    @IBAction func btnCancel(_ sender:UIButton) {
        btn_back(sender)
    }
    
    @IBAction func btnSave(_ sender:UIButton) {
       let strAboutMe = txt_about_me.text.isEmpty || txt_about_me.text == placeHolderAboutMe ? "" : txt_about_me.text
       let strIAmLookingForFriends = txt_i_am_lookin_for_friends.text.isEmpty || txt_i_am_lookin_for_friends.text == placeHolderImLookingForFriendsWho ? "" : txt_about_me.text
        
        print(dictInterest.json)
        let param = [
                "about_me":strAboutMe!,
                "friend_like":strIAmLookingForFriends!,
                "describe_me":arrDescribeMeSelected.json,
                "hobbies":arrHobies.json,
                "personal_info":dictPersonalInfo.json,
                "interest_info":dictInterest.json,
                "user_id":signUp!.userID
        ]
        print(param)
        
        let hud = KRProgressHUD.showOn(self)
        hud.show()
        APIFunc.postAPI("update_user_profile", param) { (json,status,message)  in
            DispatchQueue.main.async {
                hud.dismiss()
                
                let status = return_status(json.dictionaryObject!)
                switch status {
                case .success:
                    let decoder = JSONDecoder()
                    if let jsonData = json[result_resp].description.data(using: .utf8) {
                        do {
                            signUp = try decoder.decode(SignUp.self, from: jsonData)
                            let data = try json.rawData()
                            UserDefaults.standard.setValue(data, forKey: k_user_detals)
                            DispatchQueue.main.asyncAfter(deadline:.now()+0.2) {
                                hud.showSuccess(withMessage: message)
                                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                                    self.btn_back("")
                                }
                            }
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

//MARK:- Describe me
extension Edit_Profile_ViewController {
    func funcDropDownInterest(_ indexSelected:Int) {
        var arrInterestValue = [String]()
        
        for interest in getInterest[indexSelected].value {
            arrInterestValue.append(interest.interestValue)
        }
        
        dropDownInterest.dismissMode = .onTap
        dropDownInterest.backgroundColor = UIColor.white
        
        dropDownInterest.isMultipleTouchEnabled = true
        dropDownInterest.anchorView = tbl_profile_details
        dropDownInterest.topOffset = CGPoint(x:0, y:tbl_profile_details.bounds.height)
        dropDownInterest.dataSource = arrInterestValue
        
        dropDownInterest.selectionAction = { [weak self] (index, item) in
            dictInterest[self!.keyInterestInfo] = item
        }
        
        dropDownInterest.show()
    }
        
    @IBAction func btnBestDescribeMe(_ sender:UIButton) {
        if describeMe.count == 0 {
            func_describe_data(sender)
        } else {
            funcDropDownDescribeMe(sender)
        }
    }
    
    func funcDropDownDescribeMe(_ sender:UIButton) {
        var arrDescribeMe = [String]()
        
        for description in describeMe {
            arrDescribeMe.append(description.value)
        }
        
        dropDownDescribeMe.dismissMode = .onTap
        dropDownDescribeMe.backgroundColor = UIColor.white
        
        dropDownDescribeMe.isMultipleTouchEnabled = true
        dropDownDescribeMe.anchorView = sender
        dropDownDescribeMe.topOffset = CGPoint(x:0, y:sender.bounds.height)
        dropDownDescribeMe.dataSource = arrDescribeMe
        
        dropDownDescribeMe.multiSelectionAction = { [weak self] (index, item) in
            print(index)
            print(item)
            
            for description in describeMe {
                let dictDescribeMeSelected = ["id":description.id,
                                                "value":description.value,
                                                "created":description.created.UTCToLocal
                                                ]
                self!.arrDescribeMeSelected.append(dictDescribeMeSelected)
            }
            print(self!.arrDescribeMeSelected)
            
            var strItem = ""
            for items in item {
                strItem = strItem.isEmpty ? items : strItem+","+items
            }
            sender.setTitle(strItem, for: .normal)
        }
        dropDownDescribeMe.show()
    }
    
    func funcSaveInterest(_ valueInterest:[ValueInterest],_ index:[Int]) {
        for i in 0..<index.count {
            if arrValueInterest.count > 0 {
                for j in 0..<arrValueInterest.count {
                    if valueInterest[i].interestID != arrValueInterest[j].interestID {
                        arrValueInterest.append(valueInterest[i])
                        print("added")
                    } else {
                        print("exist")
                    }
                }
            } else {
                arrValueInterest.append(valueInterest[i])
                print("added 1")
            }
        }
    }
}



extension Edit_Profile_ViewController {
    @IBAction func txt_Search(_ sender: UITextField) {
        arrSearched = [GetHobby]()
        
        for i in 0..<arrForSearch.count {
            let model = arrForSearch[i]
            let target = model.hibbiesName
            if ((target as NSString?)?.range(of:txt_search.text!, options: .caseInsensitive))?.location == NSNotFound
            { } else {
                arrSearched.append(model)
            }
        }
        
        if (txt_search.text! == "") {
            arrSearched = arrForSearch
        }
        
        getHobbies = arrSearched
                
        arrSelected.removeAll()
        for _ in getHobbies {
            arrSelected.append(false)
        }
        
        for i in 0..<getHobbies.count {
            if arrSelectedHobbies.contains(getHobbies[i].hibbiesName) {
                arrSelected[i] = true
            }
        }
        
        tbl_profile_details.reloadData()
    }
}


