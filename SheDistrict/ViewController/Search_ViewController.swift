//  Home_ViewController.swift
//  SheDistrict
//  Created by appentus on 1/6/20.
//  Copyright © 2020 appentus. All rights reserved.
 

import UIKit
import SwiftyJSON


class Search_ViewController: UIViewController {
    @IBOutlet weak var tbl_search:UITableView!
    
    var arr_title = [String]() //["Most things in common (10 or more)","Also dog moms","They also love yoga!","Haitian, just like you!","Grab a bite to eat these foodies!"]
    var arr_user = ["Image_girl.png","Image_girl_01.png","Image_girl_02.png","Image_girl_03.png","Image_girl_04.png",]
    
    var dictUserByPreference = [String:Any]()
    var arrDictUserByPreference = [String]()
    var arrDictUserByPreferenceValue = [Any]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector:#selector(func_API_user_by_preference), name: NSNotification.Name (rawValue:"preference"), object:nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dictUserByPreference = [String:Any]()
        arrDictUserByPreference = [String]()
        arrDictUserByPreferenceValue = [Any]()
        
        func_API_user_by_preference()
    }
    
    @IBAction func btn_preferences(_ sender:UIButton) {
        func_Next_VC_Main_2("Preferences_ViewController")
    }
    
}

extension Search_ViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_title.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Search_TableViewCell
                
        if indexPath.row == 0 {
            let attr_string = NSMutableAttributedString()
            let attr_1 = func_attributed_string(font_name:"Roboto-Medium", text:"Most things in common ", color:"000000")
            let attr_2 = func_attributed_string(font_name:"Roboto-Regular", text:"(10 or more)", color:"555555")
            attr_string.append(attr_1)
            attr_string.append(attr_2)
            
            cell.lbl_title.attributedText = attr_string
        } else {
            cell.lbl_title.text = arr_title[indexPath.row]
        }
        
        let json = JSON(dictUserByPreference[arr_title[indexPath.row]] as! [[String:Any]])
        let decoder = JSONDecoder()
        if let jsonData = json.description.data(using: .utf8) {
            do {
                userAccordingPreference = try decoder.decode([UserAccordingPreference].self, from: jsonData)
            } catch {
                
            }
        }
        
        cell.coll_search.delegate = self
        cell.coll_search.dataSource = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       cell.alpha = 0
        UIView.animate(withDuration:0.25, delay:0.01, animations: {
               cell.alpha = 1
       })
    }
       
}



extension Search_ViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize (width:80, height:80)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userAccordingPreference.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"cell", for: indexPath) as! Search_CollectionCell
        
        if userAccordingPreference.count > indexPath.row {
            let userProfile = k_Base_URL_Imgae+userAccordingPreference[indexPath.row].userProfile
            cell.img_user.sd_setImage(with: URL(string:userProfile), placeholderImage:k_default_user)
        } else {
            cell.img_user.image = k_default_user
        }
        
        return cell
    }
    
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard (name:"Main_2", bundle:nil)
        let profileDetailsVC = storyboard.instantiateViewController(withIdentifier:"Profile_Details_ViewController") as! Profile_Details_ViewController
        profileDetailsVC.user_idFriend = userAccordingPreference[indexPath.row].userID
        self.navigationController?.pushViewController(profileDetailsVC, animated: true)
   }
   
}



//MARK:- API methods
import KRProgressHUD

extension Search_ViewController {
    @objc func func_API_user_by_preference() {
        let hud = KRProgressHUD.showOn(self)
        hud.show()
    
//        var arrPreference = [String]()
//
//        for (key,value) in dictPreferecenes {
//            arrPreference.append(value)
//        }
        
        let param = ["user_id":signUp!.userID,
                     "filter":dictPreferecenes.json]
        print(param)
        
        APIFunc.postAPI("user_by_preference", param) { (json,status,message) in
            DispatchQueue.main.async {
                hud.dismiss()
                
                let status = return_status(json.dictionaryObject!)
                switch status {
                case .success:
                    self.dictUserByPreference = json.dictionaryObject!["result"] as! [String:Any]
                    print(self.dictUserByPreference)
                    for (key,value) in self.dictUserByPreference {
                        self.arr_title.append(key)
                        self.arrDictUserByPreferenceValue.append(value)
                    }
                    self.tbl_search.reloadData()
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
