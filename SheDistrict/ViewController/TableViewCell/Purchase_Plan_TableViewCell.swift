//  Purchase_Plan_TableViewCell.swift
//  SheDistrict
//  Created by appentus on 1/17/20.
//  Copyright © 2020 appentus. All rights reserved.


import UIKit


class Purchase_Plan_TableViewCell: UITableViewCell {
    @IBOutlet weak var view_plan_color:UIView!
    @IBOutlet weak var img_plan_icon:UIImageView!
    @IBOutlet weak var lbl_price:UILabel!
    @IBOutlet weak var lbl_plan_time:UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
