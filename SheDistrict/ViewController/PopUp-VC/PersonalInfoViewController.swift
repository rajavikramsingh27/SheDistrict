//  PersonalInfoViewController.swift
//  SheDistrict
//  Created by Appentus Technologies on 2/15/20.
//  Copyright © 2020 appentus. All rights reserved.


import UIKit
import KRProgressHUD
import DropDown


var dictPersonalInfo = [String:Any]()


//["Age":"","Nationality":"","Ethnicity":"","Religion":"","Distance":"","Education":"","Relationship_Status":"","Sexual_Orientation":"","Has_Kids?":"","Drinking_Habits":"","Smoking_Habits":"","Political_Affiliation":""]

class PersonalInfoViewController: UIViewController {
    @IBOutlet weak var tblPersonalInfo:UITableView!
    let dropDownPersonalInfo = DropDown()
    
    var info_keyPersonalInfo = ""
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if personalInfo.count == 0 {
            func_personal_info_data()
        } else {
            tblPersonalInfo.reloadData()
        }
    }
    
    @IBAction func btnDone(_ sender:Any) {
        func_removeFromSuperview()
    }
    
    @IBAction func btnCancel(_ sender:Any) {
        func_removeFromSuperview()
    }
    
    func func_personal_info_data() {
        let hud = KRProgressHUD.showOn(self)
        hud.show()
        APIFunc.getAPI("personal_info_data", [:]) { (json, status, message) in
            DispatchQueue.main.async {
                hud.dismiss()
                if status == success_resp {
                    let decoder = JSONDecoder()
                    if let jsonData = json[result_resp].description.data(using: .utf8) {
                        do {
                            personalInfo = try decoder.decode([PersonalInfo].self, from: jsonData)
                            for personalInforam in personalInfo {
                                dictPersonalInfo[personalInforam.infoKey] = ""
                            }
                            
                            print(dictPersonalInfo)
                            self.tblPersonalInfo.reloadData()
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
    
}



extension PersonalInfoViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personalInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                
        let lblPersonalInfo =  cell.viewWithTag(1) as! UILabel
        lblPersonalInfo.text = personalInfo[indexPath.row].infoKey
        
        let lblPersonalInfoValue =  cell.viewWithTag(2) as! UILabel
        lblPersonalInfoValue.text = dictPersonalInfo[personalInfo[indexPath.row].infoKey] as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let animation = AnimationFactory.makeSlideIn(duration:0.25, delayFactor:0.01)
        let animator = Animator(animation: animation)
        animator.animate(cell: cell, at: indexPath, in: tableView)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at:indexPath,animated:true)
        
        info_keyPersonalInfo = personalInfo[indexPath.row].infoKey
        funcDropDownPersonalInfo(indexPath.row)
    }
    
    func funcDropDownPersonalInfo(_ indexSelected:Int) {
        var arrPersonalInfo = [String]()
        let dictInfoValue = personalInfo[indexSelected].infoValue.dictionary
        for (key,value) in dictInfoValue {
            arrPersonalInfo.append(value as! String)
        }
        
        dropDownPersonalInfo.dismissMode = .onTap
        dropDownPersonalInfo.backgroundColor = UIColor.white

        //        dropDownPersonalInfo.isMultipleTouchEnabled = true
        dropDownPersonalInfo.anchorView = tblPersonalInfo
        dropDownPersonalInfo.topOffset = CGPoint(x:0, y:tblPersonalInfo.bounds.height)
        dropDownPersonalInfo.dataSource = arrPersonalInfo
        dropDownPersonalInfo.selectionAction = { [weak self] (index, item) in
            print(index)
            print(item)
            
            dictPersonalInfo[self!.info_keyPersonalInfo] = item
            self?.tblPersonalInfo.reloadRows(at:[IndexPath (row: indexSelected, section: 0)], with: .automatic)
        }
        
        dropDownPersonalInfo.show()
    }
    
}


