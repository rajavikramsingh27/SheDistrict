//  Forum_List_ViewController.swift
//  SheDistrict
//  Created by appentus on 1/15/20.
//  Copyright © 2020 appentus. All rights reserved.


import UIKit


class Forum_List_ViewController: UIViewController {
    @IBOutlet weak var tbl_forum:UITableView!
    
   private let arr_header_Forum = [["General","Discussions","Comments"],
                                  ["Fashion","Discussions","Comments"],
                                  ["Health","Discussions","Comments"]]
    
    var arr_select_1 = [true,false,false]
    var arr_select_2 = [true,false,false]
    var arr_select_3 = [true,false,false]
    
    let arr_values_Forum = [["Rules","Announcements","Ideas + Feedback"],["Post 1","Post 2","Post 3"],["Post 1","Post 2","Post 3"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
}



extension Forum_List_ViewController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return arr_header_Forum.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell-header") as! Forum_Header_TableViewCell
        
        if section == 0 {
            for i in 0..<arr_select_1.count {
                if arr_select_1[i] {
                    cell.btn_headers[i].setTitleColor(hexStringToUIColor("5F71ED"), for: .normal)
                } else {
                    cell.btn_headers[i].setTitleColor(UIColor.darkGray, for: .normal)
                }
                cell.btn_headers[i].setTitle(arr_header_Forum[section][i], for: .normal)
                cell.btn_headers[i].tag = i
                cell.btn_headers[i].addTarget(self, action: #selector(btn_headers_1(_:)), for: .touchUpInside)
            }
        } else if section == 1 {
            for i in 0..<arr_select_2.count {
                if arr_select_2[i] {
                    cell.btn_headers[i].setTitleColor(hexStringToUIColor("EB40A1"), for: .normal)
                } else {
                    cell.btn_headers[i].setTitleColor(UIColor.darkGray, for: .normal)
                }
                cell.btn_headers[i].setTitle(arr_header_Forum[section][i], for: .normal)
                cell.btn_headers[i].tag = i
                cell.btn_headers[i].addTarget(self, action: #selector(btn_headers_2(_:)), for: .touchUpInside)
            }
        } else {
            for i in 0..<arr_select_3.count {
                if arr_select_3[i] {
                    cell.btn_headers[i].setTitleColor(hexStringToUIColor("47ECA5"), for: .normal)
                } else {
                    cell.btn_headers[i].setTitleColor(UIColor.darkGray, for: .normal)
                }
                cell.btn_headers[i].setTitle(arr_header_Forum[section][i], for: .normal)
                cell.btn_headers[i].tag = i
                cell.btn_headers[i].addTarget(self, action: #selector(btn_headers_3(_:)), for: .touchUpInside)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_values_Forum[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Forum_TableViewCell
        
        cell.lbl_topics.text = arr_values_Forum[indexPath.section][indexPath.row]
        
        if indexPath.row == 0 {
            cell.view_topics.roundCorners(corners: [.topLeft, .topRight], radius:20.0)
        } else if indexPath.row == arr_values_Forum[indexPath.section].count-1 {
            cell.view_topics.roundCorners(corners: [.bottomLeft, .bottomRight], radius:20.0)
        } else {
            cell.view_topics.roundCorners(corners: [.topLeft, .topRight], radius:0.0)
        }
        
        return cell
    }
    
    @IBAction func btn_headers_1( _ sender:UIButton) {
        for i in 0..<arr_select_1.count {
            if i == sender.tag {
                arr_select_1[i] = true
            } else {
                arr_select_1[i] = false
            }
        }
        
        tbl_forum.reloadData()
    }
    
    @IBAction func btn_headers_2( _ sender:UIButton) {
        for i in 0..<arr_select_2.count {
            if i == sender.tag {
                arr_select_2[i] = true
            } else {
                arr_select_2[i] = false
            }
        }
        
        tbl_forum.reloadData()
    }
    
    @IBAction func btn_headers_3( _ sender:UIButton) {
        for i in 0..<arr_select_3.count {
            if i == sender.tag {
                arr_select_3[i] = true
            } else {
                arr_select_3[i] = false
            }
        }
        
        tbl_forum.reloadData()
    }
    
}


extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
