//  Profile_TableViewCell.swift
//  SheDistrict
//  Created by appentus on 1/10/20.
//  Copyright © 2020 appentus. All rights reserved.

import UIKit

class Profile_TableViewCell: UITableViewCell {
    @IBOutlet weak var img_profile_icon:UIImageView!
    @IBOutlet weak var lbl_profile_title:UILabel!
    @IBOutlet weak var btn_select:UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
