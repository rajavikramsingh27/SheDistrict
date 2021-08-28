//  Preferences_ViewController.swift
//  SheDistrict
//  Created by appentus on 1/8/20.
//  Copyright © 2020 appentus. All rights reserved.


import UIKit
import KRProgressHUD
import DropDown


var dictPreferecenes = [String:String]()


class Preferences_ViewController: UIViewController {
    @IBOutlet weak var tbl_preference:UITableView!
    
    let arr_preferences = ["Age","Ethnicity","Nationality","Religion","Distance","Education","Relationship Status","Sexual Orientation","Has Kids?","Drinking Habits","Smoking Habits","Political Affiliation"]
    
    lazy private var menuLauncher: SelectionMenuLauncher = {
        let launcher = SelectionMenuLauncher()
        return launcher
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        preference.removeAll()
        func_get_preference()
    }
    
    @IBAction func btnCheckMark(_ sender:UIButton) {
        var arrPreference = [String]()
        
        for (key,value) in dictPreferecenes {
            arrPreference.append(value)
        }
        
        if arrPreference.isEmpty {
            return
        }
        
        btn_back("")
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            NotificationCenter.default.post(name:NSNotification.Name (rawValue:"preference"), object: nil)
        }
    }
    
    func func_get_preference() {
        let hud = KRProgressHUD.showOn(self)
        hud.show()
        APIFunc.getAPI("get_preference", [:]) { (json,status,message)  in
            DispatchQueue.main.async {
                hud.dismiss()
                
                let status = return_status(json.dictionaryObject!)
                switch status {
                case .success:
                    let decoder = JSONDecoder()
                    if let jsonData = json[result_resp].description.data(using: .utf8) {
                        do {
                            preference = try decoder.decode([Preference].self, from: jsonData)
                            
                            for pre in preference {
                                dictPreferecenes[pre.preference] = ""
                            }
                            print(dictPreferecenes)
                            self.tbl_preference.reloadData()
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

extension Preferences_ViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return preference.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Preferences_TableViewCell
        
        cell.lbl_preference_name.text = preference[indexPath.row].preference
        cell.btnSelect.tag = indexPath.row
        cell.btnSelect.addTarget(self, action: #selector(btnSelect(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let animation = AnimationFactory.makeSlideIn(duration:0.25, delayFactor:0.01)
        let animator = Animator(animation: animation)
        animator.animate(cell: cell, at: indexPath, in: tableView)
    }
    
    @IBAction func btnSelect(_ sender:UIButton) {
        var arr_drop_down = [String]()
        let strPreferenceKey = preference[sender.tag].preference
        for pre in preference[sender.tag].values {
            arr_drop_down.append(pre.valueName)
        }
        
        menuLauncher.launch(dataArray: arr_drop_down) { (index) in
            if index > -1 {
                dictPreferecenes[strPreferenceKey] = arr_drop_down[index]
            }
        }
        
    }
    
        
}



