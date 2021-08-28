//  She_Rules_Profile_VC.swift
//  SheDistrict
//  Created by appentus on 1/15/20.
//  Copyright © 2020 appentus. All rights reserved.


import UIKit
import KRProgressHUD


class She_Rules_Profile_VC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tbl_she_rules:UITableView!
    
//    let arr_header = ["1. Be Unapologetic","2. Set Healthy Boundaries","3. Trust and Loyalty","4. Commitment and Consistency","5. Respect Each Other","6. Have Fun!"]
//    let arr_description = [
//        "SheDistrict allows women to connect with other women from all walks of life. From stay-at-home moms to trophy wives and college girls to forever princesses. SheDistrict is dedicated to being a space for all types of women who enjoy different hobbies, have different interests, and live different lifestyles.",
//
//        "The reason that SheDistrict is for women only is so that women have a space where they can feel safe to make friends and be social. Setting healthy boundaries is crucial for any friendship to last.",
//
//        "Friendships can’t prosper without trust and loyalty. You’re here either because you’d like to welcome more like-minded women into your circle or you agree that sometimes it is hard to make friends, so SheDistrict is an option for you. Regardless of why you’ve joined us, it is important that any woman you decide to become friends with knows that she can trust you and that your loyalty is to your friendship. Girl Power!",
//
//        "Each of you are here for the same goal: to make friends and connections with those whose beliefs and values align with yours. It is important to be committed to creating and building your friendships. Consistency is key, so maintaining these friendships are important as well. We encourage you to get offline and be friends in person! ",
//        //        "You are all here for the same goal: to make friends and connections with those whose beliefs and values align with yours. It is important to be commited to creating and building your friendships and consictency is key in maintaining these friendships as well. SheDistrict encourages it’s members to get offline and be friends in person!",
//
//        "The best thing about SheDistrict is the freedom to choose. SheDistrict’s goal is to allow you to choose who you want to be friends with and who you want to associate with. SheDistrict has zero tolerance for abuse or harassment. We’ve made it so that you have access to the filters that allow you to show or hide profiles.",
//
//        "We’re all here to have a good time, make connections, and make long term friendships."
//    ];
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if sheRules != nil {
            sheRules.removeAll()
        }
        
        let hud = KRProgressHUD.showOn(self)
        hud.show()
        APIFunc.getAPI("she_rules", [:]) { (json,status,message) in
            DispatchQueue.main.async {
                hud.dismiss()
                
                let status = return_status(json.dictionaryObject!)
                switch status {
                case .success:
                    let decoder = JSONDecoder()
                    if let jsonData = json[result_resp].description.data(using: .utf8) {
                        do {
                            sheRules = try decoder.decode([SheRules].self, from: jsonData)
                            for i in 0..<sheRules.count{
                                sheRules[i].ruleTitle = sheRules[i].ruleTitle.htmlToAttributedString!.string
                                sheRules[i].ruleDiscription = sheRules[i].ruleDiscription.htmlToAttributedString!.string
                            }
                            self.tbl_she_rules.reloadData()
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let ruleDiscription = sheRules[indexPath.row].ruleDiscription //.htmlToAttributedString?.string
        return height_according_to_text(ruleDiscription, UIFont(name: "Roboto-Light", size:16.0)!)+50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sheRules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for:indexPath)
        
        let lbl_header = cell.viewWithTag(1) as! UILabel
        let lbl_description = cell.viewWithTag(2) as! UILabel
        
        let ruleTitle = sheRules[indexPath.row].ruleTitle //.htmlToAttributedString?.string
        lbl_header.text = "\(indexPath.row+1) "+ruleTitle
        lbl_description.text = sheRules[indexPath.row].ruleDiscription //.htmlToAttributedString?.string
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0.05 * Double(indexPath.row), animations: {
            cell.alpha = 1
        })
    }
    
}




