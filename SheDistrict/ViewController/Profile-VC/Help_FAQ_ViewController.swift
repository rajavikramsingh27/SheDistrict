//  Help_FAQ_ViewController.swift
//  SheDistrict
//  Created by appentus on 1/15/20.
//  Copyright © 2020 appentus. All rights reserved.


import UIKit
import KRProgressHUD


class Help_FAQ_ViewController: UIViewController {
    @IBOutlet weak var tbl_help_faq:UITableView!
    
    let arr_faq = ["What is SheDistrict?","Who is the founder of SheDistrict?","Why should I upload a video to my profile?","I didn’t want to upload a video, why am I being asked to do so privately","Why isn’t there a swiping feature?","Why is the \"edit profile\" section so limited?","Can I change my username?","How can I get posted on the announcment page?"]
    
    var arr_select = [Bool]()
    
    var is_animated = false
    
    var arrSearched = [AppFAQ]()
    var arrForSearch = [AppFAQ]()
    
    @IBOutlet weak var txtSearch:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appFAQ.removeAll()
        func_app_faq()
    }
    
    func func_app_faq() {
        let hud = KRProgressHUD.showOn(self)
        hud.show()
        
        APIFunc.getAPI("app_faq",[:]) { (json,status,message)  in
            DispatchQueue.main.async {
                hud.dismiss()
                
                let status = return_status(json.dictionaryObject!)
                switch status {
                case .success:
                    let decoder = JSONDecoder()
                    if let jsonData = json[result_resp].description.data(using: .utf8) {
                        do {
                            appFAQ = try decoder.decode([AppFAQ].self, from: jsonData)
                            for _ in 0..<appFAQ.count {
                                self.arr_select.append(false)
                            }
                            self.arrForSearch = appFAQ
                            self.tbl_help_faq.reloadData()
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



extension Help_FAQ_ViewController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let font =  UIFont (name: "Roboto", size: 16)!
        let width = self.view.bounds.width-112
        let height_text = heightAccordingText(arr_faq[indexPath.row],font, width)
        
        return  arr_select[indexPath.row] ? 60 + height_text : height_text+48
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appFAQ.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Help_FAQ_TableViewCell
        
        cell.lbl_faq_title.text = appFAQ[indexPath.row].question
        cell.lbl_faq_description.text = appFAQ[indexPath.row].answer
        
        cell.lbl_faq_description.isHidden = !arr_select[indexPath.row]
        
        cell.btnUpDown.isSelected = arr_select[indexPath.row]
        
        let font =  UIFont (name: "Roboto", size: 16)!
        let width = self.view.bounds.width-112
        let height_text = heightAccordingText(appFAQ[indexPath.row].question,font, width)
        
        cell.height_faq_title.constant = height_text
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor .clear
        cell.selectedBackgroundView = selectedView
        
//        cell.btn_select.tag = indexPath.row
//        cell.btn_select.addTarget(self, action: #selector(btn_select(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tbl_help_faq.beginUpdates()
        tbl_help_faq.reloadRows(at:[indexPath], with: .automatic)
        tbl_help_faq.endUpdates()
//        tbl_help_faq.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for i in 0..<arr_select.count {
            if i == indexPath.row {
                if arr_select[i] {
                    arr_select[i] = false
                } else {
                    arr_select[i] = true
                }
            }
        }
        
        tbl_help_faq.beginUpdates()
        tbl_help_faq.reloadRows(at:[indexPath], with: .automatic)
        tbl_help_faq.endUpdates()
//        tbl_help_faq.reloadData()
    }
    
    @IBAction func txtSearch(_ sender: UITextField) {
        arrSearched = [AppFAQ]()
        
        for i in 0..<arrForSearch.count {
            let model = arrForSearch[i]
            let target = model.question
            if ((target as NSString?)?.range(of:txtSearch.text!, options: .caseInsensitive))?.location == NSNotFound
            {  } else {
                arrSearched.append(model)
            }
        }
        
        if (txtSearch.text! == "") {
            arrSearched = arrForSearch
        }
        
        appFAQ = arrSearched
        
        arr_select.removeAll()
        for _ in 0..<appFAQ.count {
            arr_select.append(false)
        }
        
        tbl_help_faq.reloadData()
    }
    

}

