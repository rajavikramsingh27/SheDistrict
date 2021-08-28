//  Preferences_TableViewCell.swift
//  SheDistrict
//  Created by appentus on 1/8/20.
//  Copyright © 2020 appentus. All rights reserved.


import UIKit


class Preferences_TableViewCell: UITableViewCell {
    @IBOutlet weak var view_container:UIView!
    @IBOutlet weak var lbl_preference_name:UILabel!
    @IBOutlet weak var btnSelect:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

